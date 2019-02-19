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

class ContactTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
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

}
