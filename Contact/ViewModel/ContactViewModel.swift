//
//  ContactViewModel.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import Foundation
import RxSwift

protocol ContactViewModelling {
    // Input
    var editTapped: PublishSubject<Void> { get }
    var callTapped: PublishSubject<Void> { get }

    // Output
    var emailIdText: Observable<String> { get }
    var fullNameText: Observable<String> { get }
    var imageUrl: Observable<URL> { get }
    var editContactViewModel: Observable<EditContactViewModelling> { get }
    var mobileText: Observable<String> { get }
    var emailText: Observable<String> { get }
}

class ContactViewModel: ContactViewModelling {
    // Input
    var editTapped: PublishSubject<Void> = PublishSubject()
    var callTapped: PublishSubject<Void> = PublishSubject()
    // Output
    var emailIdText: Observable<String> = Observable.empty()
    var fullNameText: Observable<String> = Observable.empty()
    var imageUrl: Observable<URL> = Observable.empty()
    var editContactViewModel: Observable<EditContactViewModelling> = Observable.empty()
    var mobileText: Observable<String> = Observable.empty()
    var emailText: Observable<String> = Observable.empty()

    let model: ContactDetail
    init(model: ContactDetail) {
        self.model = model
        createObservables()
    }
    
    private func createObservables() {
        let firstName = model.firstName ?? ""
        let lastName = model.lastName ?? ""
        let fullName = "\(firstName) \(lastName)"
        
        emailIdText = Observable
            .just(model.email)
            .ignoreNil()
        
        fullNameText = Observable
            .just(fullName)
        
        imageUrl = Observable
            .just(model.profilePic)
            .map {Helper.toURL(with: $0)}
            .ignoreNil()
        
        mobileText = Observable
            .just(model.phoneNumber)
            .ignoreNil()
        
        emailText = Observable
            .just(model.email)
            .ignoreNil()
        
        editContactViewModel = editTapped
            .map {[unowned self] () -> EditContactViewModelling in
                EditContactViewModel(model: self.model)
            }
    }
}
