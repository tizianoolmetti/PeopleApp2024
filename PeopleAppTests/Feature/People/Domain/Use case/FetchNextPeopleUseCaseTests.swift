//
//  FetchNextPeopleUseCaseTests.swift
//  PeopleAppTests
//
//  Created by Tom Olmetti on 18/6/2024.
//

import Foundation

import XCTest

@testable import PeopleApp

final class FetchNextPeopleUseCaseTests: XCTestCase {
    
    private var repository: PeopleRepositoryMock!
    private var useCase: FetchNextPeopleUseCase!
    
    // MARK: - Constants
    let page = 2
    
    // MARK: - Test lifecycle
    override func setUp() {
        repository = PeopleRepositoryMock()
        useCase = FetchNextPeopleUseCaseImpl(repository: repository)
    }
    
    override func tearDown() {
        repository = nil
        useCase = nil
    }
    
    
    // MARK: - Test cases
    
    
    func test_fetchPeople_whenRepositoryIsSuccessfull_shouldReturnUserResponse() async {
        // Arrange
        repository.repositoryShouldFail = false
        let expectedResponse = try? StaticJSONMapper.decode(from: JSONOptionType.users.rawValue, type: UserResponse.self)
        // Act and Assert
        do {
            let res = try await useCase.fetchNextPeople(page: page)
            XCTAssertEqual(res.data.count, 6)
            XCTAssertEqual(res, expectedResponse)
        } catch {
            XCTFail("Should not throw error")
        }
    }
    
    func test_fetchPeople_whenRepositoryThrowsError_shouldThrowError() async {
        // Arrange
        repository.repositoryShouldFail = true
        // Act and Assert
        do {
            let _ = try await useCase.fetchNextPeople(page: page)
        } catch {
            guard let error = error as? HTTPClientError else {
                XCTFail("Should throw an HTTPClientError")
                return
            }
            
            XCTAssertEqual(error, HTTPClientError.decodingError)
        }
    }
}
