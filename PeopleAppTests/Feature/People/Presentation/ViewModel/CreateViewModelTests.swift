//
//  CreateViewModelTests.swift
//  PeopleAppTests
//
//  Created by Tom Olmetti on 18/6/2024.
//

import Foundation
import XCTest

@testable import PeopleApp

final class CreateViewModelTests: XCTestCase {
    // MARK: - Properties
    private var mockCreateUserUseCase: MockCreateUserUseCase!
    private var mockValidator: MockCreateValidator!
    private var viewModel: CreateViewModel!
    
    // MARK: - Title
    override func setUp() {
        mockCreateUserUseCase = MockCreateUserUseCase()
        mockValidator = MockCreateValidator()
        viewModel = CreateViewModel(createUserUseCase: mockCreateUserUseCase, validator: mockValidator)
    }
    
    override func tearDown() {
        mockCreateUserUseCase = nil
        mockValidator = nil
        viewModel = nil
    }
    
    // MARK: - Initial State
    func test_InititialState() {
        XCTAssertEqual(viewModel.dataModel.newPerson.firstName, "")
        XCTAssertEqual(viewModel.dataModel.newPerson.lastName, "")
        XCTAssertEqual(viewModel.dataModel.newPerson.job, "")
        XCTAssertNil(viewModel.dataModel.formError)
        XCTAssertEqual(viewModel.dataModel.viewState, .none)
    }
    
    // MARK: - Test Binding
    func testFirstNameBinding() {
        let binding = viewModel.firstName
        XCTAssertEqual(binding.wrappedValue, "")
        
        binding.wrappedValue = "Jane"
        XCTAssertEqual(viewModel.dataModel.newPerson.firstName, "Jane")
    }
    
    func testLastNameBinding() {
        let binding = viewModel.lastName
        XCTAssertEqual(binding.wrappedValue, "")
        
        binding.wrappedValue = "Doe"
        XCTAssertEqual(viewModel.dataModel.newPerson.lastName, "Doe")
    }
    
    func testJobBinding() {
        let binding = viewModel.job
        XCTAssertEqual(binding.wrappedValue, "")
        
        binding.wrappedValue = "Developer"
        XCTAssertEqual(viewModel.dataModel.newPerson.job, "Developer")
    }
    
    func testHasErrorBinding() {
        let binding = viewModel.hasError
        XCTAssertEqual(binding.wrappedValue, false)
        
        binding.wrappedValue = false
        XCTAssertNil(viewModel.dataModel.formError)
    }
    
    // MARK: - View State
    func testIsLoading() {
        viewModel.dataModel.viewState = .loading
        XCTAssertTrue(viewModel.isLoading)
    }
    
    func testIsloaded() {
        viewModel.dataModel.viewState = .loaded
        XCTAssertTrue(viewModel.isLoaded)
    }
    
    func testIsLoadedWithError() {
        viewModel.dataModel.viewState = .loadedWithError
        XCTAssertTrue(viewModel.isLoadedWithError)
    }
    
    
    // MARK: - Create User
    func test_createUser_whenCreateUserUseCaseIsSuccessfull_shouldSetViewStateAsLoaded() async throws {
        // Arrange
        mockCreateUserUseCase.result = .success(())
        mockValidator.result = .success(())
        // Act
        await viewModel.create()
        // Assert
        XCTAssertEqual(viewModel.dataModel.viewState, .loaded)
        XCTAssertNil(viewModel.dataModel.formError)
    }
    
    func test_createUser_whenCreateUserUseCaseThrowsError_shouldSetViewStateAsError() async throws {
        // Arrange
        mockCreateUserUseCase.result = .failure(HTTPClientError.invalidStatusCode(statusCode: 301))
        mockValidator.result = .success(())
        // Act
        await viewModel.create()
        // Assert
        XCTAssertEqual(viewModel.dataModel.viewState, .loadedWithError)
        XCTAssertEqual(viewModel.dataModel.formError?.errorDescription, "Invalid Status Code: 301")
    }
    
    func test_createUser_whenValidatorFails_shouldSetViewStateAsError() async throws {
        // Arrange
        mockCreateUserUseCase.result = .success(())
        mockValidator.result = .failure(CreateValidatorError.invalidFirstName)
        // Act
        await viewModel.create()
        // Assert
        XCTAssertEqual(viewModel.dataModel.viewState, .loadedWithError)
        XCTAssertEqual(viewModel.dataModel.formError?.errorDescription, "First name can\'t be empty")
    }
}

