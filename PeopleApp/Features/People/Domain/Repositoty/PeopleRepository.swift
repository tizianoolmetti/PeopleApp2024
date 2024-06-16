//
//  PeopleRepository.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 16/6/2024.
//

import Foundation

protocol PeopleRepository {
    func fetchPeople(page: Int) async throws -> UserResponse
    func fetchDetails(id: Int) async throws -> UserDetailsResponse
    func creteUser(data: Data?) async throws
}
