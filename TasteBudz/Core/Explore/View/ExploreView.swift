//
//  ExploreView.swift
//  TasteBudz
//
//  Created by student on 11/29/23.
//

import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    @StateObject var viewModel = ExploreViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                UserListView(viewModel: viewModel)
                    .navigationDestination(for: User.self) { user in
                        ProfileView(user: user)
                            .navigationDestination(for: Note.self, destination: { note in
                                NoteDetailsView(note: note)
                            })
                    }
            }
            .refreshable {
                Task { try await viewModel.fetchUsers() }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
