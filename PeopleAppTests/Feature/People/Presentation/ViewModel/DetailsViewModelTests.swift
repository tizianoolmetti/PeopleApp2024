//
//  DetailsViewModelTests.swift
//  PeopleAppTests
//
//  Created by Tom Olmetti on 18/6/2024.
//

import Foundation
import XCTest

@testable import PeopleApp

final class DetailsViewModelTests: XCTestCase {
    // MARK: - Properties
    private var mockfetchDetailsUseCase: MockFetchUserDetailsUseCase!
    private var viewModel: DetailsViewModel!
    
    // MARK: - Constants
    private let userId = 1
    
    // MARK: - Test lifecycle
    override func setUp() {
        mockfetchDetailsUseCase = MockFetchUserDetailsUseCase()
        viewModel = DetailsViewModel(fetchUserDetailsUseCase: mockfetchDetailsUseCase)
    }
    
    override func tearDown() {
        mockfetchDetailsUseCase = nil
        viewModel = nil
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
    
    // MARK: - Initial State
    func test_InititialState() {
        XCTAssertNil(viewModel.dataModel.userInfo)
        XCTAssertNil(viewModel.dataModel.networkingError)
        XCTAssertEqual(viewModel.dataModel.viewState, .none)
    }
    
    // MARK: - load data
    @MainActor
    func test_loadData_whenFetchDetailsUseCaseIsSuccessfull_shouldPopulateUserInfoAndSetViewStateAsLoaded() async throws {
        // arrange
        let expectedResponse = try? StaticJSONMapper.decode(from: JSONOptionType.singleUser.rawValue, type: UserDetailsResponse.self)
        mockfetchDetailsUseCase.result = .success(expectedResponse!)
        // act
        await viewModel.loadData(userId: userId)
        // assert
        XCTAssertEqual(viewModel.dataModel.userInfo, expectedResponse)
        XCTAssertEqual(viewModel.dataModel.viewState, .loaded)
        XCTAssertNil(viewModel.dataModel.networkingError)
    }
    
    @MainActor
    func test_loadData_whenFetchDetailsUseCaseThrowsError_shouldSetNetworkingErrorAndSetViewStateAsError() async throws {
        // arrange
        mockfetchDetailsUseCase.result = .failure(HTTPClientError.decodingError)
        // act
        await viewModel.loadData(userId: userId)
        // assert
        XCTAssertNil(viewModel.dataModel.userInfo)
        XCTAssertEqual(viewModel.dataModel.viewState, .loadedWithError)
        XCTAssertEqual(viewModel.dataModel.networkingError, HTTPClientError.decodingError)
    }
}
