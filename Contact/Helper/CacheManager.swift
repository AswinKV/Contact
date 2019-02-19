//
//  CacheManager.swift
//  Contact
//
//  Created by Kuliza-148 on 17/02/19.
//  Copyright © 2019 swift. All rights reserved.
//

import Foundation

/// querry if a file exists in cache with forKey.
class CacheManager {
    private var fileName: String!
    private lazy var url = {
        return Helper.getCachesDirectory().appendingPathComponent(fileName, isDirectory: false)
    }()

    func forKey(value: String) -> CacheManager {
        self.fileName = value.lowercased()
        return self
    }

    var fileExists: Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }

    func store<T: Codable>(_ object: T) throws {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            if fileExists {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            throw CacheError.unableToStore
        }
    }

    func retrieve<T: Codable>(as type: T.Type) throws -> T {
        guard fileExists else { throw CacheError.fileDoesNotExist }
        guard let data = FileManager.default.contents(atPath: url.path) else {
            fatalError("file doesn't exist.")
        }
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(type, from: data)
            return model
        } catch {
            throw CacheError.invalidData
        }
    }
}

enum CacheError: Error {
    case fileDoesNotExist
    case invalidData
    case unableToStore
}
