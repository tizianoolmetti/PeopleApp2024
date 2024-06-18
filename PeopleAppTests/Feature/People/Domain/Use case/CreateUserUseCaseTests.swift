//
//  CreateUserUseCaseTests.swift
//  PeopleAppTests
//
//  Created by Tom Olmetti on 17/6/2024.
//

import XCTest

@testable import PeopleApp

final class CreateUserUseCaseTests: XCTestCase {

    private var repository: PeopleRepositoryMock!
    private var useCase: CreateUserUseCase!
    
    // MARK: - Constants
    let userId = 1
    
    // MARK: - Test lifecycle
    override func setUp() {
        repository = PeopleRepositoryMock()
        useCase = CreateUserUseCaseImpl(repository: repository)
    }
    
    override func tearDown() {
        repository = nil
        useCase = nil
    }
    
    
    // MARK: - Test cases
    
    func test_createUser_whenRepositoryIsSuccessfull_shouldReturnVoid() async {
        // Arrange
        repository.repositoryShouldFail = false
        // Act and Assert
        do {
            let res: () = try await useCase.createUser(data: nil)
            XCTAssertTrue(res == ())
        } catch {
            XCTFail("Should not throw error")
        }
    }
    
    func test_createUser_whenRepositoryThrowsError_shouldThrowError() async {
        // Arrange
        repository.repositoryShouldFail = true
        // Act and Assert
        do {
            _ = try await useCase.createUser(data: nil)
        } catch {
            guard let error = error as? HTTPClientError else {
                XCTFail("Should throw an HTTPClientError")
                return
            }
            
            XCTAssertEqual(error, HTTPClientError.invalidStatusCode(statusCode: 301))
        }
    }

}
