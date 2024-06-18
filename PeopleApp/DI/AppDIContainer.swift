//
//  AppDIContainer.swift
//  MyPersonalWallt
//
//  Created by Tom Olmetti on 15/1/2023.
//

import SwiftUI

open class AppDIContainer {
    
    static var shared = AppDIContainer()
    
    func makeRouter() -> AppRouter {
        return AppRouter()
    }
    
    @ViewBuilder
    func rootView() -> some View {
        TabView {
            PeopleView(vm: makePeopleViewModel())
                .tabItem {
                    Symbols.person
                    Text("Home")
                }
            DetailsView(VM: makeDetailsViewModel(), userId: 2)
                .tabItem {
                    Symbols.gear
                    Text("Settings")
                }
                .environmentObject(makeDetailsViewModel())
        }
    }
    
}