//
//  DetailsViewModel.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 13/6/2024.
//

import Foundation

final class DetailsViewModel: ObservableObject {
    
    // MARK: - Published
    @Published private(set) var userInfo: UserDetailsResponse?
    
    @MainActor
    func loadData(userId: Int) {
        userInfo = try? StaticJSONMapper.decode(from: "SingleUserData", type: UserDetailsResponse.self)
    }
}
