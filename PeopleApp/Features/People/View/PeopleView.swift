//
//  PeopleView.swift
//  iOSTakeHomeProject
//
//  Created by Tunde Adegoroye on 25/06/2022.
//

import SwiftUI

struct PeopleView: View {
    
    // MARK: - StateObject
    @StateObject private var vm = PeopleViewModel()
    
    // MARK: - Properties
    let colums = Array(repeating: GridItem(.flexible()), count: 2)
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                background 
                ScrollView {
                    LazyVGrid(columns: colums, spacing: 16) {
                        ForEach(vm.users, id: \.id) { user in
                            NavigationLink {
                                DetailsView(userId: user.id)
                            } label: {
                                PersonItemView(user:user)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("People")
            .toolbar {
                ToolbarItem(placement: .primaryAction) { create }
            }
            .onAppear{
                vm.loadData()
            }
        }
    }
}

// MARK: - Views
private extension PeopleView {
    
    var background: some View {
        Theme.background
            .ignoresSafeArea(edges: .top)
    }
    
    var create: some View {
        Button {
            //            shouldShowCreate.toggle()
        } label: {
            Symbols.plus
                .font(
                    .system(.headline, design: .rounded)
                    .bold()
                )
        }
        //        .disabled(vm.isLoading)
        .accessibilityIdentifier("createBtn")
    }
}

// MARK: - Preview
struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView()
    }
}
