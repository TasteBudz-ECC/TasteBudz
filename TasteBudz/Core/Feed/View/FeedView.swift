//
//  FeedView.swift
//  TasteBudz
//
//  Created by student on 11/29/23.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.notes) { note in
                        NavigationLink(value: note) {
                            NoteCell(config: .note(note))
                        }
                    }
                    .padding(.top)
                }
            }
            .refreshable {
                Task { try await viewModel.fetchNotes() }
            }
            .overlay {
                if viewModel.isLoading { ProgressView() }
            }
            .navigationDestination(for: User.self, destination: { user in
                if user.isCurrentUser {
                    CurrentUserProfileView(didNavigate: true)
                } else {
                    ProfileView(user: user)
                }
            })
            .navigationDestination(for: Note.self, destination: { note in
                NoteDetailsView(note: note)
            })
            .navigationTitle("Notes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task { try await viewModel.fetchNotes() }
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(Color.theme.primaryText)
                    }

                }
            }
            .padding([.top, .horizontal])
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
