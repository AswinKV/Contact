//
//  UserRepository.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import RxSwift

class UserRepository: UserFetching {
    private var cacheManager: CacheManager!
    private let disposeBag = DisposeBag()
    
    func getContacts() -> Observable<[Contact]> {
        return getContactsFromAPI()
    }
    
    func getContactDetails(for identifier: String) -> Observable<ContactDetail> {
        return getContactDetailsFromAPI(for: identifier)
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
}

protocol UserFetching {
    func getContacts() -> Observable<[Contact]>
    func getContactDetails(for identifier: String) -> Observable<ContactDetail>
}
