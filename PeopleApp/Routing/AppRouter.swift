//
//  AppRouter.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 16/6/2024.
//dada

import SwiftUI

enum Destination: Identifiable {
    var id: ObjectIdentifier { ObjectIdentifier(Self.ID.self) }
    
    //MARK: - People
    case people
    case userDetails(id: Int)
    case create(successHandler: () -> Void)
}

class AppRouter {
    
   // MARK: - Using traditional DI
    @ViewBuilder
    func internalRoute(to destination: Destination) -> some View{
        switch destination {
        case .people:
            PeopleView(vm: AppDIContainer.shared.makePeopleViewModel())
        case .userDetails(let id):
            DetailsView(VM: AppDIContainer.shared.makeDetailsViewModel(), userId: id)
        case .create(let successHandler):
            CreateView(vm: AppDIContainer.shared.makeCreateViewModel(), successHandler: successHandler)
            
        }
    }
    
    // MARK: - Using EnvironmentObject
//    @ViewBuilder
//    func internalRoute(to destination: Destination) -> some View{
//        switch destination {
//        case .people:
//            PeopleView()
//                .environmentObject(AppDIContainer.shared.makePeopleViewModel())
//        case .userDetails(let id):
//            DetailsView(userId: id)
//                .environmentObject(AppDIContainer.shared.makeDetailsViewModel())
//        case .create(let successHandler):
//            CreateView(successHandler: successHandler)
//                .environmentObject(AppDIContainer.shared.makeCreateViewModel())
//            
//        }
//    }
}

