//
//  ContactsResponse.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

struct Contact: Codable {
    let favorite: Bool?
    let firstName: String?
    let identifier: Int?
    let lastName: String?
    let profilePic: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case favorite = "favorite"
        case firstName = "first_name"
        case identifier = "id"
        case lastName = "last_name"
        case profilePic = "profile_pic"
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        favorite = try values.decodeIfPresent(Bool.self, forKey: .favorite)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        identifier = try values.decodeIfPresent(Int.self, forKey: .identifier)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        profilePic = try values.decodeIfPresent(String.self, forKey: .profilePic)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }
}
