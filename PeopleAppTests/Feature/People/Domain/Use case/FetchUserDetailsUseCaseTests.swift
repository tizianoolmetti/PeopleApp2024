//
//  FetchUserDetailsUseCaseTests.swift
//  PeopleAppTests
//
//  Created by Tom Olmetti on 17/6/2024.
//

import XCTest
@testable import PeopleApp

final class FetchUserDetailsUseCaseTests: XCTestCase {

    private var repository: PeopleRepositoryMock!
    private var useCase: FetchUserDetailsUseCase!
    
    // MARK: - Constants
    let userId = 1
    
    // MARK: - Test lifecycle
    override func setUp() {
        repository = PeopleRepositoryMock()
        useCase = FetchUserDetailsUseCaseImpl(repository: repository)
    }
    
    override func tearDown() {
        repository = nil
        useCase = nil
    }
    
    
    // MARK: - Test cases
    
    func test_fetchUserDetails_whenRepositoryIsSuccessfull_shouldReturnUserDetailsResponse() async {
        // Arrange
        repository.repositoryShouldFail = false
        let expectedResponse = try? StaticJSONMapper.decode(from: JSONOptionType.singleUser.rawValue, type: UserDetailsResponse.self)
        // Act and Assert
            let res = try? await useCase.fetchUserDetails(userId: userId)
            XCTAssertEqual(res, expectedResponse)
    }
    
    func test_fetchPeople_whenRepositoryThrowsError_shouldThrowError() async {
        // Arrange
        repository.repositoryShouldFail = true
        // Act and Assert
        do {
            let _ = try await useCase.fetchUserDetails(userId: userId)
        } catch {
            guard let error = error as? HTTPClientError else {
                XCTFail("Should throw an HTTPClientError")
                return
            }
            
            XCTAssertEqual(error, HTTPClientError.decodingError)
        }
    }
}
