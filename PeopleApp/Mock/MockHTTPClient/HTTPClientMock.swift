//
//  HTTPClientMock.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 17/6/2024.
//

import Foundation

class HTTPClientMock: HTTPClientProtocol {
    
    init() {}
    
    func request<T:Codable>(endpoint: Endpoint, type: T.Type, staticJsonOption: JSONOptionType, statusCode: Int = 200) async throws -> T {
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLSessionProtocol.self]
        let session = URLSession(configuration: configuration)
        
        guard
            let path = Bundle.main.path(forResource: staticJsonOption.rawValue, ofType: "json"),
            let data = FileManager.default.contents(atPath: path)
        else {
            throw HTTPClientError.customError(error: "Missing file: \(staticJsonOption.rawValue).json")
        }
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: endpoint.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
             
            return (response!, data)
        }
        
        do {
            let res = try await HTTPClient.shared.request(session: session, endpoint: .people(page: 1), type: T.self)
            return res
        } catch {
            guard let error = error as? HTTPClientError else {
                throw HTTPClientError.customError(error: "Got the wrong type of error. Should throw an HTTPClientError")
            }
            throw error
        }
    }

    func request(endpoint: Endpoint, statusCode: Int = 200) async throws {
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLSessionProtocol.self]
        let session = URLSession(configuration: configuration)
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: endpoint.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
             
            return (response!, nil)
        }
        
        do {
            _ = try await HTTPClient.shared.request(session: session, endpoint: .create(data: nil))
        } catch {
            guard let error = error as? HTTPClientError else {
                throw HTTPClientError.customError(error: "Got the wrong type of error. Should throw an HTTPClientError")
            }
            throw error
        }
    }
    
}
