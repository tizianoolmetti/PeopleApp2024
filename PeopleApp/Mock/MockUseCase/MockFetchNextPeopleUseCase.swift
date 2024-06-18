//
//  MockFetchNextPeopleUseCase.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 18/6/2024.
//

import Foundation

class MockFetchNextPeopleUseCase: FetchNextPeopleUseCase {
    
    var result: Result<UserResponse, Error>?
    
    init(result: Result<UserResponse, Error>? = nil) {
        self.result = result
    }
                                                       
    func fetchNextPeople(page: Int) async throws -> UserResponse {
        switch result {
            case .success(let response):
                return response
            case .failure(let error):
                throw error
            case .none:
            throw HTTPClientError.customError(error: "Result not set")
        }
    }
}
