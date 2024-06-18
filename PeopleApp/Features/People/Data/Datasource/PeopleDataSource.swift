//
//  PeopleDataSource.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 16/6/2024.
//

import Foundation

protocol PeopleDataSource {
    func fetchPeople(page: Int) async throws -> UserResponse
    func fetchDetails(id: Int) async throws -> UserDetailsResponse
    func creteUser(data: Data?) async throws
}

class PeopleDataSourceImpl: PeopleDataSource {
    
    let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol = HTTPClient() ) {
        self.httpClient = httpClient
    }
    
    func fetchPeople(page: Int) async throws -> UserResponse {
        do {
            return try await httpClient.request(endpoint: .people(page: page), type: UserResponse.self)
        } catch {
            throw error
        }
    }
    
    func fetchDetails(id: Int) async throws -> UserDetailsResponse {
        do {
            return try await httpClient.request(endpoint: .details(id: id), type: UserDetailsResponse.self)
        } catch {
            throw error
        }
    }
    
    func creteUser(data: Data?) async throws {
        do {
            try await httpClient.request(endpoint: .create(data: data))
        } catch {
            throw error
        }
    }
}
