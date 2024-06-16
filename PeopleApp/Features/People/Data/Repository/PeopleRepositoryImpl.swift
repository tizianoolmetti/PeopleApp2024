//
//  PeopleRepositoryImpl.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 16/6/2024.
//

import Foundation

class PeopleRepositoryImpl: PeopleRepository {
    
    let dataSource: PeopleDataSource
    
    init(dataSource: PeopleDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchPeople(page: Int) async throws -> UserResponse {
        try await dataSource.fetchPeople(page: page)
    }
    
    func fetchDetails(id: Int) async throws -> UserDetailsResponse {
        try await  dataSource.fetchDetails(id: id)
    }
    
    func creteUser(data: Data?) async throws {
        try await dataSource.creteUser(data: data)
    }
}
