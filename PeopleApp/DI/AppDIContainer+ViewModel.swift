//
//  AppDIContainer+ViewModel.swift
//  MyPersonalWallt
//
//  Created by Tom Olmetti on 16/1/2023.
//

import Foundation

extension AppDIContainer {
    
    //MARK: - People
    func makePeopleViewModel() -> PeopleViewModel {
        return PeopleViewModel(router: makeRouter(), fetchPeopleUseCase: makeFetchPeopleUseCase())
    }
    
    func makeCreateViewModel() -> CreateViewModel {
        return CreateViewModel(createUserUseCase: makeCreateUserUseCase())
    }
    
    func makeDetailsViewModel() -> DetailsViewModel {
        return DetailsViewModel(fetchDetailsUseCase: makeFetchUserDetailsUseCase())
    }
    
}
