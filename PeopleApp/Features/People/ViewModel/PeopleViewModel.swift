//
//  PeopleViewModel.swift
//  iOSTakeHomeProject
//
//  Created by Tunde Adegoroye on 02/07/2022.
//

import Foundation

final class PeopleViewModel: ObservableObject {
    
    @Published var users = [User]()
    
    func loadData() {
        users = try! StaticJSONMapper.decode(from: "UsersStaticData", type: UserResponse.self).data
    }
}
