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
    var emailString: PublishSubject<String?> { get }
    var mobileString: PublishSubject<String?> { get }
    var firstNameString: PublishSubject<String?> { get }
    var lastNameString: PublishSubject<String?> { get }
    var uploadTapped: PublishSubject<Void> { get }
    // Output
    var contactUpdated: Observable<Contact> { get }
}

class AddContactViewModel: AddContactViewModelling {
    // Input
    var doneTapped: PublishSubject<Void> = PublishSubject()
    var cancelTapped: PublishSubject<Void> = PublishSubject()
    var emailString: PublishSubject<String?> = PublishSubject()
    var mobileString: PublishSubject<String?> = PublishSubject()
    var firstNameString: PublishSubject<String?> = PublishSubject()
    var lastNameString: PublishSubject<String?> = PublishSubject()
    var uploadTapped: PublishSubject<Void> = PublishSubject()
    // Output
    var contactUpdated: Observable<Contact> = Observable.empty()
    
    let repository: ContactFetching
    init(repository: ContactFetching) {
        self.repository = repository
        createObservables()
    }
    
    private func createObservables() {
        
        contactUpdated =  Observable
            .combineLatest(mobileString,
                           emailString,
                           firstNameString,
                           lastNameString)
            .sample(doneTapped)
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
}
