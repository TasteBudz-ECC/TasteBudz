//
//  UserListView.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

//import SwiftUI

import SwiftUI

struct UserListView: View {
    @ObservedObject var viewModel: ExploreViewModel
    @State private var searchText = ""
    
    var users: [User] {
        return searchText.isEmpty ? viewModel.users : viewModel.filteredUsers(searchText)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(users) { user in
                    NavigationLink(value: user) {
                        UserCell(user: user)
                            .padding(.leading)
                    }
                }
                
            }
            .navigationTitle("Search")
            .padding(.top)
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer)
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView(viewModel: ExploreViewModel())
    }
}
