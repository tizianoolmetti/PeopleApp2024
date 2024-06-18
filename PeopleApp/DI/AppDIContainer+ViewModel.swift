//
//  AppDIContainer+ViewModel.swift
//  MyPersonalWallt
//
//  Created by Tom Olmetti on 16/1/2023.
//

import Foundation

extension AppDIContainer {
    
    //MARK: - People View Model
    func makePeopleViewModel() -> PeopleViewModel {
        return PeopleViewModel(router: makeRouter(), fetchPeopleUseCase: makeFetchPeopleUseCase(), fetchNextPeopleUseCase: makeFetchNextPeopleUseCase())
    }
    
    func makeCreateViewModel() -> CreateViewModel {
        return CreateViewModel(createUserUseCase: makeCreateUserUseCase(),
                               validator: makeCreateValidator())
    }
    
    func makeDetailsViewModel() -> DetailsViewModel {
        return DetailsViewModel(fetchUserDetailsUseCase: makeFetchUserDetailsUseCase())
    }
    
}
