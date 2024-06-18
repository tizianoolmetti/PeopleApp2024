//
//  MockCreateUserUseCase.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 18/6/2024.
//

import Foundation

class MockCreateUserUseCase: CreateUserUseCase {
    
    var result: Result<Void, Error>? = nil
    
    func createUser(data: Data?) async throws {
        switch result {
            case .success:
                return ()
            case .failure(let error):
                throw error
            case .none:
                fatalError("Result not set")
        }
    }
}
