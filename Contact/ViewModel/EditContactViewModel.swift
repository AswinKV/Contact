//
//  ContactViewModel.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import Foundation
import RxSwift

protocol EditContactViewModelling {
    // Input
    var doneTapped: PublishSubject<Void> { get }
    var cancelTapped: PublishSubject<Void> { get }
    var emailString: PublishSubject<String> { get }
    var mobileString: PublishSubject<String> { get }
    var firstNameString: PublishSubject<String> { get }
    var lastNameString: PublishSubject<String> { get }
    var uploadTapped: PublishSubject<Void> { get }
    // Output
    var mobileText: Observable<String> { get }
    var emailText: Observable<String> { get }
    var firstNameText: Observable<String> { get }
    var lastNameText: Observable<String> { get }
    var contactUpdated: Observable<Contact> { get }
    var errorObservable: Observable<String?> { get }
}

class EditContactViewModel: EditContactViewModelling {
    // Input
    var doneTapped: PublishSubject<Void> = PublishSubject()
    var cancelTapped: PublishSubject<Void> = PublishSubject()
    var emailString: PublishSubject<String> = PublishSubject()
    var mobileString: PublishSubject<String> = PublishSubject()
    var firstNameString: PublishSubject<String> = PublishSubject()
    var lastNameString: PublishSubject<String> = PublishSubject()
    var uploadTapped: PublishSubject<Void> = PublishSubject()
    // Output
    var mobileText: Observable<String> = Observable.empty()
    var emailText: Observable<String> = Observable.empty()
    var firstNameText: Observable<String> = Observable.empty()
    var lastNameText: Observable<String> = Observable.empty()
    var errorObservable: Observable<String?> = Observable.empty()
    private var firstNameError: Observable<String?> = Observable.empty()
    private var mobileError: Observable<String?> = Observable.empty()
    private var emailError: Observable<String?> = Observable.empty()
    var contactUpdated: Observable<Contact> = Observable.empty()
    
    private lazy var inputs: Observable = {
        return Observable.combineLatest(mobileString,
                                        emailString,
                                        firstNameString,
                                        lastNameString)
    }()

    let model: ContactDetail
    let repository: ContactFetching
    init(model: ContactDetail, repository: ContactFetching) {
        self.model = model
        self.repository = repository
        createObservables()
    }
    
    private func createObservables() {
        mobileText = Observable
            .just(model.phoneNumber)
            .ignoreNil()
        
        emailText = Observable
            .just(model.email)
            .ignoreNil()
        
        firstNameText = Observable
            .just(model.firstName)
            .ignoreNil()
        
        lastNameText = Observable
            .just(model.lastName)
            .ignoreNil()
        
        emailError = doneTapped
            .withLatestFrom(emailString.startWith(""))
            .map { [unowned self] email in
                self.alertIfInvalid(email: email)
        }
        
        mobileError = doneTapped
            .withLatestFrom(mobileString.startWith(""))
            .map { [unowned self] phone in
                self.alertIfInvalid(phone: phone)
        }
        
        firstNameError = doneTapped
            .withLatestFrom(firstNameString.startWith(""))
            .map { [unowned self] name in
                self.alertIfInvalid(name: name)
        }
        
        errorObservable = Observable.zip(mobileError, emailError, firstNameError).map { mobileError, emailError, firstNameError in
            if let mobileError = mobileError {
                return mobileError
            } else if let emailError = emailError {
                return emailError
            } else if let firstNameError = firstNameError {
                return firstNameError
            }
            return nil
        }
        
        contactUpdated =  errorObservable
            .filter {
                $0 == nil
            }
            .withLatestFrom(inputs)
            .map {(mobile, email, firstName, lastName) -> ContactRequest in
                ContactRequest(email: email, favourite: false, firstName: firstName, lastName: lastName, phoneNumber: mobile)
            }
            .flatMap { [unowned self] in
                self.create(contact: $0)
            }
    }
    
    private func create(contact: ContactRequest) -> Observable<Contact> {
        return repository.createContact(with: contact)
    }
    
    // MARK: - Email validation logic
    
    private func alertIfInvalid(email: String) -> String? {
        return isValidEmail(value: email) ? nil : DisplayString.Validation.invalidEmail
    }
    
    private func isValidEmail(value: String) -> Bool {
        return validate(value: value) && validateRegex(with: value)
    }
    
    private func validate(value: String) -> Bool {
        return !value.isEmpty
    }
    
    private func validateRegex(with value: String) -> Bool {
        let regTest = NSPredicate(format: "SELF MATCHES %@", AppConstants.Regex.email)
        return regTest.evaluate(with: value)
    }
    
    // MARK: - Phone validation logic
    
    private func alertIfInvalid(phone: String) -> String? {
        return isValid(phone: phone) ? nil : DisplayString.Validation.invalidPhone
    }
    
    private func isValid(phone: String) -> Bool {
        return validate(value: phone) && validate(phone: phone)
    }
    
    func validate(phone: String) -> Bool {
        let regTest = NSPredicate(format: "SELF MATCHES %@", AppConstants.Regex.phone)
        return regTest.evaluate(with: phone)
    }
    
    // MARK :- Name validation logic
    
    private func alertIfInvalid(name: String) -> String? {
        return validate(value: name) ? nil : DisplayString.Validation.invalidName
    }
    
    private func updateContact(contact: ContactRequest) -> Observable<Contact> {
        guard let identifier = model.id else { fatalError() }
        return repository.updateContact(with: identifier.description, and: contact)
    }
}
