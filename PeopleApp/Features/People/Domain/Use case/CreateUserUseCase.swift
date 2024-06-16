//
//  CreateUserUseCase.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 16/6/2024.
//

import Foundation

protocol CreateUserUseCase {
    func createUser(data: Data?) async throws
}

class CreateUserUseCaseImpl: CreateUserUseCase {
    
    let repository: PeopleRepository
    
    init(repository: PeopleRepository) {
        self.repository = repository
    }
    
    func createUser(data: Data?) async throws {
        try await repository.creteUser(data: data)
    }
}
