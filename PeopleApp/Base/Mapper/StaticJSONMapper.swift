//
//  StaticJSONMapper.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 13/6/2024.
//

import Foundation

enum StaticJSONMapperError: Error {
    case fileNotFound
    case decodingError
}

struct StaticJSONMapper {
    
    static func decode<T: Codable>(from fileName: String, type: T.Type) throws -> T {
        
        guard
            let path = Bundle.main.path(forResource: fileName, ofType: "json"),
            let data = FileManager.default.contents(atPath: path) else {
            throw StaticJSONMapperError.fileNotFound
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
           return try decoder.decode(T.self, from: data)
        } catch {
            throw StaticJSONMapperError.decodingError
        }
    }
}


