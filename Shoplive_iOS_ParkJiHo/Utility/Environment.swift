//
//  Environment.swift
//  Shoplive_iOS_ParkJiHo
//
//  Created by jiho park on 5/22/24.
//

import Foundation

enum Environment {
    enum Key: String {
        case baseURL = "BASE_URL"
        case MarvelAPIKey = "MARVEL_API_KEY"
        case MarvelAPIHash = "MARVEL_API_HASH"
    }
    
    static func value(forKey key: Key) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String else {
            fatalError("Invalid value or undefined key : \(key)")
        }
        return value
    }
}
