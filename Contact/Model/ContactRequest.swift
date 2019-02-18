//
//  ContactDetail.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import Foundation

struct ContactRequest : Codable {
    let email: String?
    let favorite: Bool?
    let firstName: String?
    let lastName: String?
    let phoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case favorite = "favorite"
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        favorite = try values.decodeIfPresent(Bool.self, forKey: .favorite)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
    }
    
    init(email: String?, favourite: Bool?, firstName: String?, lastName: String?, phoneNumber: String?) {
        self.email = email
        self.favorite = favourite
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
    }
}
