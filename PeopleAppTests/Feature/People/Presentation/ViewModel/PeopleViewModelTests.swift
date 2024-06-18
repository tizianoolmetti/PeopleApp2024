//
//  PeopleViewModelTests.swift
//  PeopleAppTests
//
//  Created by Tom Olmetti on 18/6/2024.
//

import XCTest

@testable import PeopleApp

final class PeopleViewModelTests: XCTestCase {
    private var mockRouter: AppRouter!
    private var mockFetchPeopleUseCase: MockFetchPeopleUseCase!
    private var mockFetchNextPeopleUseCase: MockFetchNextPeopleUseCase!
    private var viewModel: PeopleViewModel!
    
    override func setUp() {
        mockRouter = AppRouter()
        mockFetchPeopleUseCase = MockFetchPeopleUseCase()
        mockFetchNextPeopleUseCase = MockFetchNextPeopleUseCase()
        viewModel = PeopleViewModel(
            router: mockRouter,
            fetchPeopleUseCase: mockFetchPeopleUseCase,
            fetchNextPeopleUseCase: mockFetchNextPeopleUseCase
        )
    }
    
    override func tearDown() {
        mockRouter = nil
        mockFetchPeopleUseCase = nil
        mockFetchNextPeopleUseCase = nil
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
        XCTAssertEqual(viewModel.dataModel.users, [])
        XCTAssertNil(viewModel.dataModel.networkingError)
        XCTAssertFalse(viewModel.dataModel.shouldShowCreate)
        XCTAssertEqual(viewModel.dataModel.viewState, .none)
        XCTAssertEqual(viewModel.page, 1)
        XCTAssertNil(viewModel.totalPage)
    }
    
    // MARK: - load data
    @MainActor
    func test_loadData_whenFetchPeopleUseCaseIsSuccessfull_shouldPopulateUsersAndSetViewStateAsLoaded() async throws {
        // arrange
        let expectedResponse = try? StaticJSONMapper.decode(from: JSONOptionType.users.rawValue, type: UserResponse.self)
        mockFetchPeopleUseCase.result = .success(expectedResponse!)
        // act
        await viewModel.loadData()
        // assert
        XCTAssertEqual(viewModel.dataModel.users.count, 6)
        XCTAssertEqual(viewModel.dataModel.viewState, .loaded)
        XCTAssertNil(viewModel.dataModel.networkingError)
        XCTAssertFalse(viewModel.dataModel.shouldShowCreate)
    }
    
    @MainActor
    func test_loadData_whenFetchPeopleUseCaseThrowsError_shouldSetNetworkingErrorAndSetViewStateAsLoadedWithError() async {
        // arrange
        mockFetchPeopleUseCase.result = .failure(HTTPClientError.decodingError)
        // act
        await viewModel.loadData()
        // assert
        XCTAssertTrue(viewModel.dataModel.users.isEmpty)
        XCTAssertEqual(viewModel.dataModel.viewState, .loadedWithError)
        XCTAssertEqual(viewModel.dataModel.networkingError, HTTPClientError.decodingError)
        XCTAssertFalse(viewModel.dataModel.shouldShowCreate)
    }
    
    // MARK: - Load Next Page
    @MainActor
    func test_loadNextPage_whenFetchPeopleUseCaseIsSuccessfull_shouldAppendUsersAndSetViewStateAsLoaded() async throws {
        // arrange
        let expectedResponse = try? StaticJSONMapper.decode(from: JSONOptionType.users.rawValue, type: UserResponse.self)
        mockFetchPeopleUseCase.result = .success(expectedResponse!)
        mockFetchNextPeopleUseCase.result = .success(expectedResponse!)
        // act
        await viewModel.loadData()
        await viewModel.loadNextPage()
        // assert
        XCTAssertEqual(viewModel.dataModel.users.count, 12)
        XCTAssertEqual(viewModel.dataModel.viewState, .loaded)
        XCTAssertNil(viewModel.dataModel.networkingError)
        XCTAssertFalse(viewModel.dataModel.shouldShowCreate)
    }
    
    @MainActor
    func test_loadNextPage_whenFetchPeopleUseCaseThrowsError_shouldSetNetworkingErrorAndSetViewStateAsLoadedWithError() async {
        // arrange
        let expectedResponse = try? StaticJSONMapper.decode(from: JSONOptionType.users.rawValue, type: UserResponse.self)
        mockFetchPeopleUseCase.result = .success(expectedResponse!)
        mockFetchNextPeopleUseCase.result = .failure(HTTPClientError.decodingError)
        // act
        await viewModel.loadData()
        await viewModel.loadNextPage()
        // assert
        XCTAssertEqual(viewModel.dataModel.users.count, 6)
        XCTAssertEqual(viewModel.dataModel.viewState, .loadedWithError)
        XCTAssertEqual(viewModel.dataModel.networkingError, HTTPClientError.decodingError)
        XCTAssertFalse(viewModel.dataModel.shouldShowCreate)
    }
    
    // MARK: - Show Create
    func test_showCreate() {
        viewModel.showCreate()
        XCTAssertTrue(viewModel.dataModel.shouldShowCreate)
    }
    
    // MARK: - reset
    func test_reset() {
        viewModel.reset()
        XCTAssertEqual(viewModel.dataModel.users, [])
        XCTAssertNil(viewModel.dataModel.networkingError)
        XCTAssertFalse(viewModel.dataModel.shouldShowCreate)
        XCTAssertEqual(viewModel.dataModel.viewState, .none)
        XCTAssertEqual(viewModel.page, 1)
        XCTAssertNil(viewModel.totalPage)
    }
}
