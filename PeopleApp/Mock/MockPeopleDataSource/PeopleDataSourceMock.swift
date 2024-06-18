//
//  PeopleDataSourceMock.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 17/6/2024.
//

import Foundation

class PeopleDataSourceMock: PeopleDataSource {
    let httpClient = HTTPClientMock()
    var dataSourceShouldFail = false
    
    var statusCode: Int {
        dataSourceShouldFail ? 301 : 200
    }
    
    func fetchPeople(page: Int) async throws -> PeopleApp.UserResponse {
        try await httpClient.request(endpoint: .people(page: 1), type: UserResponse.self, staticJsonOption: .users, statusCode: statusCode)
    }
    
    func fetchDetails(id: Int) async throws -> PeopleApp.UserDetailsResponse {
        try await httpClient.request(endpoint: .details(id: 1), type: UserDetailsResponse.self, staticJsonOption: .singleUser, statusCode: statusCode)
    }
    
    func creteUser(data: Data?) async throws {
        try await httpClient.request(endpoint: .create(data: nil), statusCode: statusCode)
    }
}
