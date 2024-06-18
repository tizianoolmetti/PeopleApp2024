//
//  PeopleRepositoryMock.swift
//  PeopleAppTests
//
//  Created by Tom Olmetti on 17/6/2024.
//

import Foundation

class PeopleRepositoryMock: PeopleRepository {
    
    var repositoryShouldFail: Bool = false
    
    func fetchPeople(page: Int) async throws -> PeopleApp.UserResponse {
        if repositoryShouldFail {
            try await PeopleDataSourceFailMock().fetchPeople(page: 1)
        } else {
            try await PeopleDataSourceSuccessMock().fetchPeople(page: 1)
        }
    }
    
    func fetchDetails(id: Int) async throws -> PeopleApp.UserDetailsResponse {
       if repositoryShouldFail {
            try await PeopleDataSourceFailMock().fetchDetails(id: 1)
        } else {
            try await PeopleDataSourceSuccessMock().fetchDetails(id: 1)
        }
    }
    
    func creteUser(data: Data?) async throws {
        if repositoryShouldFail {
            try await PeopleDataSourceFailMock().creteUser(data: nil)
        } else {
            try await PeopleDataSourceSuccessMock().creteUser(data: nil)
        }
    }
}
