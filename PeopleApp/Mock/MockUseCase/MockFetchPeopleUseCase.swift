//
//  MockFetchPeopleUseCase.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 18/6/2024.
//

import Foundation

class MockFetchPeopleUseCase: FetchPeopleUseCase {
    
    var result: Result<UserResponse, Error>?
    
    init(result: Result<UserResponse, Error>? = nil) {
        self.result = result
    }
                                                       
    func fetchPeople(page: Int) async throws -> UserResponse {
        switch result {
            case .success(let response):
                return response
            case .failure(let error):
                throw error
            case .none:
               throw HTTPClientError.customError(error: "No result provided")
        }
    }
}
