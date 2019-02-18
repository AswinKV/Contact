//
//  Encodable+Extension.swift
//  Contact
//
//  Created by Kuliza-148 on 18/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import Foundation
extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
