//
//  UserRepository.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import RxSwift
import Foundation

class ContactRepository: ContactFetching {
    private var cacheManager: CacheManager!
    private let disposeBag = DisposeBag()
    
    func getContacts() -> Observable<[Contact]> {
        return getContactsFromAPI()
    }
    
    func getContactDetails(for identifier: String) -> Observable<ContactDetail> {
        return getContactDetailsFromAPI(for: identifier)
    }
    
    func updateContact(with identifier: String, and contact: ContactRequest) -> Observable<Contact> {
        guard let dict = try? contact.asDictionary() else { fatalError() }
        let parameter = Parameters(url: identifier,
                                   json: dict)
        return updateContactApi(with: parameter)
        
    }

    private func getContactsFromAPI() -> Observable<[Contact]> {
        let provider = NetworkProvider<[Contact]>(apiType: Api.getContacts)
        let serviceLoader = ServiceLoader(apiCall: provider.fetchResponse)
        return serviceLoader.item
    }
    
    private func getContactDetailsFromAPI(for identifier: String) -> Observable<ContactDetail> {
        let provider = NetworkProvider<ContactDetail>(apiType: Api.getAContact(withId: identifier))
        let serviceLoader = ServiceLoader(apiCall: provider.fetchResponse)
        return serviceLoader.item
    }
    
    func updateContactApi(with parameters: Parameters) -> Observable<Contact> {
        let provider = NetworkProvider<Contact>(apiType: Api.putAContact(parameters))
        let serviceLoader = ServiceLoader(apiCall: provider.fetchResponse)
        return serviceLoader.item
    }
}

protocol ContactFetching {
    func getContacts() -> Observable<[Contact]>
    func getContactDetails(for identifier: String) -> Observable<ContactDetail>
    func updateContact(with identifier: String, and contact: ContactRequest) -> Observable<Contact>
}


extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
