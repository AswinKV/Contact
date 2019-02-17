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
    var fullNameText: Observable<String> { get }
    var imageUrl: Observable<URL> { get }
}

class EditContactViewModel: EditContactViewModelling {
    // Input
    var doneTapped: PublishSubject<Void> = PublishSubject()
    var cancelTapped: PublishSubject<Void> = PublishSubject()
    var emailIdText: PublishSubject<String> = PublishSubject()
    // Output
    var fullNameText: Observable<String> = Observable.empty()
    var imageUrl: Observable<URL> = Observable.empty()
    
    let model: ContactDetail
    init(model: ContactDetail) {
        self.model = model
        createObservables()
    }
    
    private func createObservables() {
        let firstName = model.firstName ?? ""
        let lastName = model.lastName ?? ""
        let fullName = "\(firstName) \(lastName)"
        
        fullNameText = Observable
            .just(fullName)
        
        imageUrl = Observable
            .just(model.profilePic)
            .map {Helper.toURL(with: $0)}
            .ignoreNil()
    }
}
