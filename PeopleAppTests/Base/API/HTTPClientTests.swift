//
//  HTTPClientTests.swift
//  PeopleAppTests
//
//  Created by Tom Olmetti on 17/6/2024.
//

import XCTest

@testable import PeopleApp

final class HTTPClientTests: XCTestCase {
    
    private var session: URLSession!
    private var url: URL!
    
    override func setUp() {
        url = URL(string: "https://reqres.in/api/users")
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLSessionProtocol.self]
        session = URLSession(configuration: configuration)
    }
    
    override func tearDown() {
        session = nil
        url = nil
    }
    

    func test_urlSession_withSuccessfulResponse_shouldReturnData() async {
       
        guard 
            let path = Bundle.main.path(forResource: JSONOptionType.users.rawValue, ofType: "json"),
            let data = FileManager.default.contents(atPath: path)
        else {
            XCTFail("Missing file: \(JSONOptionType.users.rawValue).json")
            return
        }
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
             
            return (response!, data)
        }
        
        do {
            let res = try await HTTPClient.shared.request(session: session, endpoint: .people(page: 1), type: UserResponse.self)
            
            let staticJson = try? StaticJSONMapper.decode(from: JSONOptionType.users.rawValue, type: UserResponse.self)
            
            XCTAssertEqual(res, staticJson, "The response should be equal to the static json")
            
        } catch {
            XCTFail("Error: \(error.localizedDescription)")
        }
    }
    
    func test_urlSession_withSuccessfulResponse_shouldReturnVoid() async {
       
        guard
            let path = Bundle.main.path(forResource: JSONOptionType.users.rawValue, ofType: "json"),
            let data = FileManager.default.contents(atPath: path)
        else {
            XCTFail("Missing file: \(JSONOptionType.users.rawValue).json")
            return
        }
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
             
            return (response!, data)
        }
        
        do {
           _ = try await HTTPClient.shared.request(session: session, endpoint: .create(data: nil))
            
        } catch {
            XCTFail("Error: \(error.localizedDescription)")
        }
    }
    
    func test_urlSession_withInvalidStatusCode_shouldThrowHTTPClientErrorInvalidStatusCode() async {
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url, statusCode: 301, httpVersion: nil, headerFields: nil)
             
            return (response!, nil)
        }
        
        do {
            _ = try await HTTPClient.shared.request(session: session, endpoint: .people(page: 1))
            XCTFail("Should throw an error")
        } catch {
            guard let httpError = error as? HTTPClientError else {
                XCTFail("Got the wrong type of error. Should throw an HTTPClientError")
                return
            }
            
            XCTAssertEqual(
                httpError,
                HTTPClientError.invalidStatusCode(statusCode: 301),
                "Should be equal to HTTPClientError.invalidStatusCode(statusCode: 301)"
            )
        }
    }
    
    func test_urlSession_withInvalidJson_shouldThrowHTTPClientErroDecodingError() async {
        
        guard
            let path = Bundle.main.path(forResource: JSONOptionType.users.rawValue, ofType: "json"),
            let data = FileManager.default.contents(atPath: path)
        else {
            XCTFail("Missing file: \(JSONOptionType.users.rawValue).json")
            return
        }
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
             
            return (response!, data)
        }
        
        do {
            let _ = try await HTTPClient.shared.request(session: session, endpoint: .people(page: 1), type: UserDetailsResponse.self)
            XCTFail("Should throw an error")
        } catch {
            guard let httpError = error as? HTTPClientError else {
                XCTFail("Got the wrong type of error. Should throw an HTTPClientError")
                return
            }
            
            XCTAssertEqual(
                httpError,
                HTTPClientError.decodingError,
                "Should be equal to HTTPClientError.decodingError"
            )
        }
    }
    
}
