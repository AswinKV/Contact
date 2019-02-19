//
//  ContactViewModel.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import Foundation
import RxSwift

protocol AddContactViewModelling {
    // Input
    var doneTapped: PublishSubject<Void> { get }
    var cancelTapped: PublishSubject<Void> { get }
    var textFieldDidEndEditing: PublishSubject<Void> { get }
    var emailString: PublishSubject<String> { get }
    var mobileString: PublishSubject<String> { get }
    var firstNameString: PublishSubject<String> { get }
    var lastNameString: PublishSubject<String> { get }
    var uploadTapped: PublishSubject<Void> { get }
    // Output
    var contactUpdated: Observable<Contact> { get }
    var errorObservable: Observable<String?> { get }
}

class AddContactViewModel: AddContactViewModelling {
    // Input
    var doneTapped: PublishSubject<Void> = PublishSubject()
    var cancelTapped: PublishSubject<Void> = PublishSubject()
    var firstNameDidEndEditing: PublishSubject<Void> = PublishSubject()
    var textFieldDidEndEditing: PublishSubject<Void> = PublishSubject()
    var firstNameString: PublishSubject<String> = PublishSubject()
    var lastNameString: PublishSubject<String> = PublishSubject()
    var emailString: PublishSubject<String> = PublishSubject()
    var mobileString: PublishSubject<String> = PublishSubject()
    var uploadTapped: PublishSubject<Void> = PublishSubject()
    // Output
    var contactUpdated: Observable<Contact> = Observable.empty()
    var errorObservable: Observable<String?> = Observable.empty()

    private var firstNameError: Observable<String?> = Observable.empty()
    private var mobileError: Observable<String?> = Observable.empty()
    private var emailError: Observable<String?> = Observable.empty()
    private lazy var inputs: Observable = {
        return Observable.combineLatest(mobileString,
                           emailString,
                           firstNameString,
                           lastNameString)
    }()

    let repository: ContactFetching
    init(repository: ContactFetching) {
        self.repository = repository
        createObservables()
    }

    private func createObservables() {

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

    // MARK: - Name validation logic

    private func alertIfInvalid(name: String) -> String? {
        return validate(value: name) ? nil : DisplayString.Validation.invalidName
    }
}
