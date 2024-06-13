//
//  ContentView.swift
//  PeopleApp
//
//  Created by Tom Olmetti on 13/6/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var userDetailsResponse: UserDetailsResponse?
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
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
    }
}

#Preview {
    ContentView()
}
