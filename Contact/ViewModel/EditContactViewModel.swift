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
    var emailIdText: PublishSubject<String> { get }
    // Output
    var mobileText: Observable<String> { get }
    var emailText: Observable<String> { get }
    var firstNameText: Observable<String> { get }
    var lastNameText: Observable<String> { get }

}

class EditContactViewModel: EditContactViewModelling {
    // Input
    var doneTapped: PublishSubject<Void> = PublishSubject()
    var cancelTapped: PublishSubject<Void> = PublishSubject()
    var emailIdText: PublishSubject<String> = PublishSubject()
    // Output
    var mobileText: Observable<String> = Observable.empty()
    var emailText: Observable<String> = Observable.empty()
    var firstNameText: Observable<String> = Observable.empty()
    var lastNameText: Observable<String> = Observable.empty()

    let model: ContactDetail
    init(model: ContactDetail) {
        self.model = model
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
    }
}
