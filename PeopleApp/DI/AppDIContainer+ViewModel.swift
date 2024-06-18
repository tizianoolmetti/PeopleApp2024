//
//  AppDIContainer+ViewModel.swift
//  MyPersonalWallt
//
//  Created by Tom Olmetti on 16/1/2023.
//

import Foundation

extension AppDIContainer {
    
    //MARK: - People View Model
    func makePeopleViewModel() -> PeopleViewModel {
        // This is a way to test the UI with a success networking response
        #if DEBUG
        if UITestingHelper.isUITesting {
            return mockPeopleViewModelForUITests()
        }
        #endif
        
        return PeopleViewModel(router: makeRouter(), fetchPeopleUseCase: makeFetchPeopleUseCase(), fetchNextPeopleUseCase: makeFetchNextPeopleUseCase())
    }
    
    func makeCreateViewModel() -> CreateViewModel {
        return CreateViewModel(createUserUseCase: makeCreateUserUseCase(),
                               validator: makeCreateValidator())
    }
    
    func makeDetailsViewModel() -> DetailsViewModel {
        // This is a way to test the UI with a success networking response
        #if DEBUG
        if UITestingHelper.isUITesting {
            return mockDetailsViewModelForUITests()
        }
        #endif
        return DetailsViewModel(fetchUserDetailsUseCase: makeFetchUserDetailsUseCase())
    }
    
}

extension AppDIContainer {
    
    func mockPeopleViewModelForUITests() -> PeopleViewModel {
        if UITestingHelper.isPeopleNetworkingSuccess {
            let mockResponse = try? StaticJSONMapper.decode(from: JSONOptionType.users.rawValue, type: UserResponse.self)
            
            return PeopleViewModel(router: makeRouter(), fetchPeopleUseCase: MockFetchPeopleUseCase(result: .success(mockResponse!)), fetchNextPeopleUseCase: MockFetchNextPeopleUseCase(result: .success(mockResponse!)))
        } else {
            return PeopleViewModel(router: makeRouter(), fetchPeopleUseCase: MockFetchPeopleUseCase(result: .failure(HTTPClientError.invalidStatusCode(statusCode: 301))), fetchNextPeopleUseCase: MockFetchNextPeopleUseCase(result: .failure(HTTPClientError.invalidStatusCode(statusCode: 301))))
        }
    }
    
    func mockDetailsViewModelForUITests() -> DetailsViewModel {
        if UITestingHelper.isDetailsNetworkingSuccess {
            let mockResponse = try? StaticJSONMapper.decode(from: JSONOptionType.singleUser.rawValue, type: UserDetailsResponse.self)
            
            return DetailsViewModel(fetchUserDetailsUseCase: MockFetchUserDetailsUseCase(result: .success(mockResponse!)))
        } else {
            return DetailsViewModel(fetchUserDetailsUseCase: MockFetchUserDetailsUseCase(result: .failure(HTTPClientError.invalidStatusCode(statusCode: 301)))
            )
        }
    }
}
