//
//  ContactTests.swift
//  ContactTests
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import XCTest
@testable import Contact
import RxBlocking
import RxSwift

class ContactTests: XCTestCase {

    var disposeBag = DisposeBag()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testContactResponseModel() {
        let provider = MockContactFetching()
        do {
            guard let firstContact = try provider.getContacts().toBlocking().first()?.first,
                let firstName = firstContact.firstName else {
                XCTFail("error occured while parsing")
                return
            }
            XCTAssertEqual(firstName, "1223")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testCaching() {
        let contact = ContactRequest(email: "aisling.linux@gmail.com", favourite: true, firstName: "Aswin", lastName: "K", phoneNumber: "7975644718")
        let cacheManager = CacheManager()
        // try inserting the object.
        do {
            try cacheManager.forKey(value: "aswin").store(contact)
        } catch {
            XCTFail(error.localizedDescription)
        }
        // try fetching the object back.
        do {
            let contactFromCache = try cacheManager.forKey(value: "aswin").retrieve(as: ContactRequest.self)
            guard let email = contactFromCache.email else { return }
            XCTAssertEqual(email, "aisling.linux@gmail.com")
        } catch {
            XCTFail(error.localizedDescription)
        }

    }

    func testAddContactViewModelError() {
        // test to check the error validation logic. this should return an error.
        let provider = MockContactFetching()
        let viewModel = AddContactViewModel(repository: provider)
        viewModel.errorObservable.subscribe(onNext: { (error) in
            guard let error = error else { return }
            XCTAssertEqual(error, DisplayString.Validation.invalidPhone)
        }).disposed(by: disposeBag)
        viewModel.doneTapped.onNext(())
    }

}
