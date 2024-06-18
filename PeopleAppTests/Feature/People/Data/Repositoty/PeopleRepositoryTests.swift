//
//  PeopleRepositoryTests.swift
//  PeopleAppTests
//
//  Created by Tom Olmetti on 17/6/2024.
//

import Foundation

import XCTest

@testable import PeopleApp

final class PeopleRepositoryTests: XCTestCase {
    
    private var dataSource: PeopleDataSourceMock!
    private var repository: PeopleRepository!
    
    // MARK: - Constants
    private let userId = 1
    private let page = 1
    private let expectedStatusCodeError = 301
    
    // MARK: - Tets Life Cycle
    override func setUp() {
        dataSource = PeopleDataSourceMock()
        repository = PeopleRepositoryImpl(dataSource: dataSource)
    }
    
    override func tearDown() {
        dataSource = nil
    }
    
    // MARK: - Fetch People
    func test_fetchPeople_whenDataSourceIsSuccessfull_shouldReturnUserResponse() async {
        // Arrange
        let expectedResponse = try? StaticJSONMapper.decode(from: JSONOptionType.users.rawValue, type: UserResponse.self)
        // Act and Assert
            let res = try? await dataSource.fetchPeople(page: page)
            XCTAssertEqual(res?.data.count, 6)
            XCTAssertEqual(res, expectedResponse)
    }
    
    func test_fetchPeople_whenDataSourceThrowsError_shouldThrowError() async {
        // Arrange
        dataSource.dataSourceShouldFail = true
        // Act and Assert
        do {
            let _ = try await dataSource.fetchPeople(page: page)
        } catch {
            guard let error = error as? HTTPClientError else {
                XCTFail("Should throw an HTTPClientError")
                return
            }
            XCTAssertEqual(error, HTTPClientError.invalidStatusCode(statusCode: expectedStatusCodeError))
        }
    }
    
    // MARK: - Fetch User Details
    func test_fetchUserDetails_whenDataSourceIsSuccessfull_shouldReturnUserDetailsResponse() async {
        // Arrange
        let expectedResponse = try? StaticJSONMapper.decode(from: JSONOptionType.singleUser.rawValue, type: UserDetailsResponse.self)
        // Act and Assert
            let res = try? await dataSource.fetchDetails(id: userId)
            XCTAssertEqual(res?.data.id, userId)
            XCTAssertEqual(res, expectedResponse)
    }
    
    func test_fetchUserDetails_whenDataSourceThrowsError_shouldThrowError() async {
        // Arrange
        dataSource.dataSourceShouldFail = true
        // Act and Assert
        do {
            let _ = try await dataSource.fetchDetails(id: userId)
        } catch {
            guard let error = error as? HTTPClientError else {
                XCTFail("Should throw an HTTPClientError")
                return
            }
            
            XCTAssertEqual(error, HTTPClientError.invalidStatusCode(statusCode: expectedStatusCodeError))
        }
    }
    
    // MARK: - Create User
    func test_createUser_whenDataSourceIsSuccessfull_shouldReturnVoid() async {
        // Arrange
        dataSource.dataSourceShouldFail = false
        // Act and Assert
        let res: () = try! await dataSource.creteUser(data: nil)
        XCTAssertTrue(res == ())
    }
    
    func test_createUser_whenDataSourceThrowsError_shouldThrowError() async {
        // Arrange
        dataSource.dataSourceShouldFail = true
        // Act and Assert
        do {
            _ = try await dataSource.creteUser(data: nil)
        } catch {
            guard let error = error as? HTTPClientError else {
                XCTFail("Should throw an HTTPClientError")
                return
            }
            
            XCTAssertEqual(error, HTTPClientError.invalidStatusCode(statusCode: expectedStatusCodeError))
        }
    }
}


