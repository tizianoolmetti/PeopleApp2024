//
//  EndpointTests.swift
//  PeopleAppTests
//
//  Created by Tom Olmetti on 17/6/2024.
//

import XCTest

@testable import PeopleApp

final class EndpointTests: XCTestCase {
    
    func test_people_endpoint_request_is_valid () {
        let endpoint = Endpoint.people(page: 1)
        
        XCTAssertEqual(endpoint.host, "reqres.in", "Host should be reqres.in")
        XCTAssertEqual(endpoint.path, "/api/users", "Path should be /api/users")
        XCTAssertEqual(endpoint.methodType.rawValue, "GET", "Method type should be GET")
        XCTAssertEqual(endpoint.queryItems.count, 1, "Query items should be 1")
        XCTAssertEqual(endpoint.queryItems.first?.name, "page", "Query item name should be page")
        XCTAssertEqual(endpoint.queryItems.first?.value, "1", "Query item value should be 1")
        XCTAssertEqual(endpoint.url?.absoluteString, "https://reqres.in/api/users?delay=1&page=1" ,"https://reqres.in/api/users?delay=1&page=1")
    }
    
    func test_details_endpoint_request_is_valid () {
        let endpoint = Endpoint.details(id: 1)
        let id =  1
        
        XCTAssertEqual(endpoint.host, "reqres.in", "Host should be reqres.in")
        XCTAssertEqual(endpoint.path, "/api/users/\(id)", "Path should be /api/users/\(id)")
        XCTAssertEqual(endpoint.methodType.rawValue, "GET", "Method type should be GET")
        XCTAssertEqual(endpoint.queryItems.count, 0, "Query items should be 0")
        XCTAssertEqual(endpoint.url?.absoluteString, "https://reqres.in/api/users/1?delay=1" ,"https://reqres.in/api/users/1?delay=1")
    }
    
    func test_create_endpoint_request_is_valid () {
        let endpoint = Endpoint.create(data: nil)
        
        XCTAssertEqual(endpoint.host, "reqres.in", "Host should be reqres.in")
        XCTAssertEqual(endpoint.path, "/api/users", "Path should be /api/users")
        XCTAssertEqual(endpoint.methodType.rawValue, "POST", "Method type should be POST")
        XCTAssertEqual(endpoint.queryItems.count, 0, "Query items should be 0")
        XCTAssertEqual(endpoint.url?.absoluteString, "https://reqres.in/api/users?delay=1" ,"https://reqres.in/api/users?delay=1")
    }

}
