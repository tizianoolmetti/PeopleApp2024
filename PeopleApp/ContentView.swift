//
//  ContentView.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 13/6/2024.
//

import SwiftUI

enum Destination: Hashable {
    case peopleView
    case detailsView
    case settingsView
}

struct ContentView: View {
    @State var path = NavigationPath()
    
    @State private var userDetailsResponse: UserDetailsResponse?
    
    func navigateTo(_ view: Destination) {
            path.append(view)
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                    .onTapGesture {
                        navigateTo(.settingsView)
                    }
                Text(userDetailsResponse?.data.firstName ?? "Loading...")
                    .font(.title)
                    .fontWeight(.bold)
                Text(userDetailsResponse?.data.lastName ?? "Loading...")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding()
            .onAppear {
                userDetailsResponse = try? StaticJSONMapper.decode(from: "SingleUserData", type: UserDetailsResponse.self)
                dump(userDetailsResponse?.data)
        }
            .navigationDestination(for: Destination.self) { destination in
                            switch destination {
                            case .detailsView:
                                DetailsView(userId: 1)
                            case .peopleView:
                                PeopleView()
                            case .settingsView:
                                Text("Setting")
                                    .onTapGesture {
                                        navigateTo(.detailsView)
                                    }
                            }
                        }
            
        }
    }
}

#Preview {
    ContentView()
}
