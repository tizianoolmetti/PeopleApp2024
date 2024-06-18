//
//  PeopleDataSourceTests.swift
//  PeopleAppTests
//
//  Created by Tom Olmetti on 17/6/2024.
//

import XCTest

@testable import PeopleApp

final class PeopleDataSourceTests: XCTestCase {
    
    private var mockHTTPClient: HTTPClientMock!
    private var dataSource: PeopleDataSource!

    override func setUp() {
        mockHTTPClient = HTTPClientMock()
        dataSource = PeopleDataSourceImpl(httpClient: mockHTTPClient)
    }
    
    override func tearDown() {
        mockHTTPClient = nil
        dataSource = nil
    }
    
    
    // MARK: - Fetch People
    
    func test_fetchPeople_whenHTTPResponseIsSuccessful_shouldReturnUserResponse() async{
        // Arrange
        let page = 1
        let expectedResponse = try? StaticJSONMapper.decode(from: JSONOptionType.users.rawValue, type: UserResponse.self)
        // Act and Assert
        do {
            let res = try await mockHTTPClient.request(endpoint: .people(page: page), type: UserResponse.self, staticJsonOption: .users, statusCode: 200)
            XCTAssertEqual(res.data.count, 6)
            XCTAssertEqual(res, expectedResponse)
        } catch {
            XCTFail("Should not throw error")
        }
    }
    
    func test_fetchPeople_whenHTTPResponseThrowsError_shouldThrowError() async {
        // Arrange
        let page = 1
        // Act and Assert
        do {
            let _ = try await mockHTTPClient.request(endpoint: .people(page: page), type: UserResponse.self, staticJsonOption: .users, statusCode: 301)
        } catch {
            guard let error = error as? HTTPClientError else {
                XCTFail("Should throw an HTTPClientError")
                return
            }
            
            XCTAssertEqual(error, HTTPClientError.invalidStatusCode(statusCode: 301))
        }
    }
    
    // MARK: - Fetch Details
    func test_fetchDetails_whenHTTPResponseIsSuccessful_shouldReturnUserDetailsResponse() async {
        // Arrange
        let id = 1
        let expectedResponse = try? StaticJSONMapper.decode(from: JSONOptionType.singleUser.rawValue, type: UserDetailsResponse.self)
        // Act and Assert
        do {
            let res = try await mockHTTPClient.request(endpoint: .details(id: id), type: UserDetailsResponse.self, staticJsonOption: .singleUser, statusCode: 200)
            XCTAssertEqual(res, expectedResponse)
        } catch {
            XCTFail("Should not throw error")
        }
    }
    
    func test_fetchDetails_whenHTTPResponseThrowsError_shouldThrowError() async {
        // Arrange
        let id = 1
        // Act and Assert
        do {
            let _ = try await mockHTTPClient.request(endpoint: .details(id: id), type: UserDetailsResponse.self, staticJsonOption: .singleUser, statusCode: 301)
        } catch {
            guard let error = error as? HTTPClientError else {
                XCTFail("Should throw an HTTPClientError")
                return
            }
            
            XCTAssertEqual(error, HTTPClientError.invalidStatusCode(statusCode: 301))
        }
    }
    
    // MARK: - Create User
    func test_createUser_whenHTTPResponseIsSuccessful_shouldNotThrowError() async {
        // Arrange
        let data = Data()
        // Act and Assert
        do {
            try await mockHTTPClient.request(endpoint: .create(data: data), statusCode: 200)
        } catch {
            XCTFail("Should not throw error")
        }
    }
    
    func test_createUser_whenHTTPResponseThrowsError_shouldThrowError() async {
        // Arrange
        let data = Data()
        // Act and Assert
        do {
            try await mockHTTPClient.request(endpoint: .create(data: data), statusCode: 301)
        } catch {
            guard let error = error as? HTTPClientError else {
                XCTFail("Should throw an HTTPClientError")
                return
            }
            
            XCTAssertEqual(error, HTTPClientError.invalidStatusCode(statusCode: 301))
        }
    }
}
