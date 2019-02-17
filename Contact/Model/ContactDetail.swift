//
//  ContactDetail.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

struct ContactDetail: Codable {
    let createdAt: String?
    let email: String?
    let favorite: Bool?
    let firstName: String?
    let id: Int?
    let lastName: String?
    let phoneNumber: String?
    let profilePic: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case email = "email"
        case favorite = "favorite"
        case firstName = "first_name"
        case id = "id"
        case lastName = "last_name"
        case phoneNumber = "phone_number"
        case profilePic = "profile_pic"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        favorite = try values.decodeIfPresent(Bool.self, forKey: .favorite)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        phoneNumber = try values.decodeIfPresent(String.self, forKey: .phoneNumber)
        profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
        updatedAt = try values.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}
