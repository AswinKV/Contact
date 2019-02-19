//
//  NetworkLayer.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import Foundation

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum ParamsEncoding: String {
    case json
    case url
}

struct Parameters {
    let url: String
    let json: [String: Any]
}

protocol ApiType {
    var baseURL: URL { get }
    var path: String { get }
    var method: RequestMethod { get }
    var parameters: [String: Any]? { get }
    var parameterEncoding: ParamsEncoding { get }
}

enum Api {
    case getContacts
    case getAContact(withId: String)
    case postContacts([String: Any])
    case putAContact(Parameters)
}

extension Api: ApiType {

    var baseURL: URL {
        return URL(string: "\(AppConstants.baseURL)/")!
    }

    var path: String {
        switch self {
        case .getContacts:
            return "contacts.json"
        case .getAContact(let identifier):
            return "contacts/\(identifier).json"
        case .postContacts:
            return "contacts.json"
        case .putAContact(let parameters):
            return "contacts/\(parameters.url).json"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getContacts:
            return .get
        case .getAContact:
            return .get
        case .postContacts:
            return .post
        case .putAContact:
            return .put
        }
    }

    var parameters: [String: Any]? {
        var parameters = [String: Any]()
        switch self {
        case .putAContact(let parameter) :
            for (key, value) in parameter.json {
                parameters[key] = value
            }
        default :
            break
        }
        return parameters
    }

    var parameterEncoding: ParamsEncoding {
        switch self {
        case .putAContact:
            return .json
        default:
            return .url
        }
    }
}
