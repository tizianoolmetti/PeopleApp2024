//
//  FetchNextPeopleUseCase.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 18/6/2024.
//

import Foundation

protocol FetchNextPeopleUseCase {
    func fetchNextPeople(page: Int) async throws -> UserResponse
}

class FetchNextPeopleUseCaseImpl: FetchNextPeopleUseCase {
    
    let repository: PeopleRepository
    
    init(repository: PeopleRepository) {
        self.repository = repository
    }
    
    func fetchNextPeople(page: Int) async throws -> UserResponse {
        try await repository.fetchPeople(page: page)
    }
}
