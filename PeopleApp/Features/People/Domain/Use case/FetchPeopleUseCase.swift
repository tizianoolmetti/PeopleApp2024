//
//  FetchPeopleUseCase.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 16/6/2024.
//

import Foundation

protocol FetchPeopleUseCase {
    func fetchPeople(page: Int) async throws -> UserResponse
}

class FetchPeopleUseCaseImpl: FetchPeopleUseCase {
    
    let repository: PeopleRepository
    
    init(repository: PeopleRepository) {
        self.repository = repository
    }
    
    func fetchPeople(page: Int) async throws -> UserResponse {
        try await repository.fetchPeople(page: page)
    }
}
