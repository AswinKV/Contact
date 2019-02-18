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
    var emailString: PublishSubject<String?> { get }
    var mobileString: PublishSubject<String?> { get }
    var firstNameString: PublishSubject<String?> { get }
    var lastNameString: PublishSubject<String?> { get }
    var uploadTapped: PublishSubject<Void> { get }
    // Output
    var mobileText: Observable<String> { get }
    var emailText: Observable<String> { get }
    var firstNameText: Observable<String> { get }
    var lastNameText: Observable<String> { get }
    var contactUpdated: Observable<Contact> { get }
}

class EditContactViewModel: EditContactViewModelling {
    // Input
    var doneTapped: PublishSubject<Void> = PublishSubject()
    var cancelTapped: PublishSubject<Void> = PublishSubject()
    var emailString: PublishSubject<String?> = PublishSubject()
    var mobileString: PublishSubject<String?> = PublishSubject()
    var firstNameString: PublishSubject<String?> = PublishSubject()
    var lastNameString: PublishSubject<String?> = PublishSubject()
    var uploadTapped: PublishSubject<Void> = PublishSubject()
    // Output
    var mobileText: Observable<String> = Observable.empty()
    var emailText: Observable<String> = Observable.empty()
    var firstNameText: Observable<String> = Observable.empty()
    var lastNameText: Observable<String> = Observable.empty()
    var contactUpdated: Observable<Contact> = Observable.empty()

    let model: ContactDetail
    let repository: ContactFetching
    init(model: ContactDetail, repository: ContactFetching) {
        self.model = model
        self.repository = repository
        createObservables()
    }
    
    private func createObservables() {
        let favourite = model.favorite
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
        
        contactUpdated =  Observable
            .combineLatest(mobileString.startWith(model.phoneNumber),
                           emailString.startWith(model.email),
                           firstNameString.startWith(model.firstName),
                           lastNameString.startWith(model.lastName))
            .sample(doneTapped)
            .map {(mobile, email, firstName, lastName) -> ContactRequest in
                ContactRequest(email: email, favourite: favourite, firstName: firstName, lastName: lastName, phoneNumber: mobile)
            }
            .flatMap { [unowned self] in
                self.updateContact(contact: $0)
            }
    }
    
    private func updateContact(contact: ContactRequest) -> Observable<Contact> {
        guard let identifier = model.id else { fatalError() }
        return repository.updateContact(with: identifier.description, and: contact)
    }
}
