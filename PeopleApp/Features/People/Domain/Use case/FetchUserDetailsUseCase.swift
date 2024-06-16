//
//  FetchUserDetailsUseCase.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 16/6/2024.
//

import Foundation

protocol FetchUserDetailsUseCase {
    func fetchUserDetails(userId: Int) async throws -> UserDetailsResponse
}

class FetchUserDetailsUseCaseImpl: FetchUserDetailsUseCase {
    
    let repository: PeopleRepository
    
    init(repository: PeopleRepository) {
        self.repository = repository
    }
    
    func fetchUserDetails(userId: Int) async throws -> UserDetailsResponse {
        try await repository.fetchDetails(id: userId)
    }
}
