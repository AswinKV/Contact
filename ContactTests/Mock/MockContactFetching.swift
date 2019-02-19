//
//  MockContactFetching.swift
//  ContactTests
//
//  Created by Kuliza-148 on 19/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import Foundation
@testable import Contact
import RxSwift

class MockContactFetching: ContactFetching {
    func getContacts() -> Observable<[Contact]> {
        let provider = MockDataProvider<[Contact]>(apiType: Api.getContacts)
        let serviceLoader = ServiceLoader(apiCall: provider.fetchResponse)
        return serviceLoader.item
    }
    
    func getContactDetails(for identifier: String) -> Observable<ContactDetail> {
        fatalError()
    }
    
    func updateContact(with identifier: String, and contact: ContactRequest) -> Observable<Contact> {
        fatalError()
    }
    
    func createContact(with contact: ContactRequest) -> Observable<Contact> {
        fatalError()
    }
    
    
}
