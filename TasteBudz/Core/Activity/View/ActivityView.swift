//
//  ActivityView.swift
//  TasteBudz
//
//  Created by student on 11/29/23.
//

import SwiftUI

struct ActivityView: View {
    @StateObject var viewModel = ActivityViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ActivityFilterView(selectedFilter: $viewModel.selectedFilter)
                        .padding(.vertical)

                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.notifications) { activityModel in
                            if activityModel.type != .friend {
                                NavigationLink(value: activityModel) {
                                    ActivityRowView(model: activityModel)
                                }
                            } else {
                                NavigationLink(value: activityModel.user) {
                                    ActivityRowView(model: activityModel)
                                }
                            }
                        }
                    }
                }
            }
            .refreshable {
                Task { try await viewModel.isLoading }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationTitle("Activity")
            .navigationDestination(for: ActivityModel.self, destination: { model in
                if let note = model.note {
                    NoteDetailsView(note: note)
                }
            })
            .navigationDestination(for: User.self, destination: { user in
                ProfileView(user: user)
            })
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
