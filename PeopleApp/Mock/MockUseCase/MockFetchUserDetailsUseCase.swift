//
//  MockFetchUserDetailsUseCase.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 18/6/2024.
//

import Foundation

class MockFetchUserDetailsUseCase: FetchUserDetailsUseCase {
    
    var result: Result<UserDetailsResponse, Error>?
    
    init(result: Result<UserDetailsResponse, Error>? = nil) {
        self.result = result
    }
    
    func fetchUserDetails(userId: Int) async throws -> UserDetailsResponse {
        switch result {
            case .success(let user):
                return user
            case .failure(let error):
                throw error
            case .none:
                throw HTTPClientError.customError(error: "Result not set")
        }
    }
}
