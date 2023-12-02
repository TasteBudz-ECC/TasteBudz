//
//  UserContentListView.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//
import SwiftUI

struct UserContentListView: View {
    @Binding var selectedFilter: ProfileNoteFilterViewModel
    @StateObject var viewModel: UserContentListViewModel
    @Namespace var animation
    
    init(selectedFilter: Binding<ProfileNoteFilterViewModel>, user: User) {
        self._selectedFilter = selectedFilter
        self._viewModel = StateObject(wrappedValue: UserContentListViewModel(user: user))
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(ProfileNoteFilterViewModel.allCases) { option in
                    VStack {
                        Text(option.title)
                            .font(.subheadline)
                            .fontWeight(selectedFilter == option ? .semibold : .regular)
                        
                        if selectedFilter == option {
                            Rectangle()
                                .foregroundStyle(Color.theme.primaryText)
                                .frame(width: 180, height: 1)
                                .matchedGeometryEffect(id: "item", in: animation)
                        } else {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(width: 180, height: 1)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedFilter = option
                        }
                    }
                }
            }
            .padding(.vertical, 4)
            
            LazyVStack {
                if selectedFilter == .notes {
                    if viewModel.notes.isEmpty {
                        Text(viewModel.noContentText(filter: .notes))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.notes) { note in
                            NoteCell(config: .note(note))
                        }
                        .transition(.move(edge: .leading))
                    }
                } else {
                    if viewModel.replies.isEmpty {
                        Text(viewModel.noContentText(filter: .replies))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.replies) { reply in
                            NoteReplyCell(reply: reply)
                        }
                        .transition(.move(edge: .trailing))
                    }
                }
            }
            
            .padding(.vertical, 8)
        }
    }
}

struct UserContentListView_Previews: PreviewProvider {
    static var previews: some View {
        UserContentListView(
            selectedFilter: .constant(.notes),
            user: dev.user
        )
    }
}
