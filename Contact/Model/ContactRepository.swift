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
    
    init(cacheManager: CacheManager) {
        self.cacheManager = cacheManager
    }

    func getContacts() -> Observable<[Contact]> {
        do {
            let contacts = try getContactsFromCache()
            if !contacts.isEmpty {
                return returnContactsObservable(contacts: contacts)
            }
        } catch {
            print("log to crash reporting -> \(error.localizedDescription)")
        }
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

    func createContact(with contact: ContactRequest) -> Observable<Contact> {
        guard let dict = try? contact.asDictionary() else { fatalError() }
        return createContactApi(with: dict)
    }
    
    private func getContactDetailsFromAPI(for identifier: String) -> Observable<ContactDetail> {
        let provider = NetworkProvider<ContactDetail>(apiType: Api.getAContact(withId: identifier))
        let serviceLoader = ServiceLoader(apiCall: provider.fetchResponse)
        showLoader(observable: serviceLoader.refreshing)
        return serviceLoader.item
    }
    
    func updateContactApi(with parameters: Parameters) -> Observable<Contact> {
        let provider = NetworkProvider<Contact>(apiType: Api.putAContact(parameters))
        let serviceLoader = ServiceLoader(apiCall: provider.fetchResponse)
        showLoader(observable: serviceLoader.refreshing)
        return serviceLoader.item
    }
    
    func createContactApi(with parameters: [String : Any]) -> Observable<Contact> {
        let provider = NetworkProvider<Contact>(apiType: Api.postContacts(parameters))
        let serviceLoader = ServiceLoader(apiCall: provider.fetchResponse)
        showLoader(observable: serviceLoader.refreshing)
        return serviceLoader.item
    }
    
    //    MARK :- Logic to fetch contacts from either cache or API

    private func cache<T: Codable>(response: T) {
        do {
            try cacheManager.forKey(value: "contacts").store(response)
        } catch let error {
            print("log to crash reporting -> \(error)")
        }
    }

    private func getContactsFromCache() throws -> [Contact] {
        do {
            let contacts = try cacheManager.forKey(value: "contacts").retrieve(as: [Contact].self)
            return contacts
        } catch {
            throw CacheError.fileDoesNotExist
        }
    }
    
    private func getContactsFromAPI() -> Observable<[Contact]> {
        let provider = NetworkProvider<[Contact]>(apiType: Api.getContacts)
        let serviceLoader = ServiceLoader(apiCall: provider.fetchResponse)
        showLoader(observable: serviceLoader.refreshing)
        cacheFromObservable(observable: serviceLoader.item)
        return serviceLoader.item
    }
    
    private func cacheFromObservable<T: Codable>(observable: Observable<T>) {
        observable.subscribe(onNext: { [weak self](response) in
            self?.cache(response: response)
        }).disposed(by: disposeBag)
    }
    
    private func returnContactsObservable(contacts: [Contact]) -> Observable<[Contact]> {
        return Observable<[Contact]>.create { (observer) -> Disposable in
            observer.onNext(contacts)
            return Disposables.create()
        }
    }
    
    //    MARK :- Logic to show loader
    private func showLoader(observable: Observable<Bool>) {
        observable.subscribe(onNext: { (isRefreshing) in
            switch isRefreshing {
            case true: Helper.showIndicator()
            case false: Helper.hideIndicator()
            }
        }).disposed(by: disposeBag)
    }
}

protocol ContactFetching {
    func getContacts() -> Observable<[Contact]>
    func getContactDetails(for identifier: String) -> Observable<ContactDetail>
    func updateContact(with identifier: String, and contact: ContactRequest) -> Observable<Contact>
    func createContact(with contact: ContactRequest) -> Observable<Contact>
}
