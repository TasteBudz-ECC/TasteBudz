//
//  ProfileView.swift
//  TasteBudz
//
//  Created by student on 11/4/23.
//

import SwiftUI
struct ProfileView: View {
    @State private var selectedFilter: ProfileNoteFilter = .notes
    
    // the filterBarWidth adjusts according to the cases in ProfileNoteFilter rather than hardcoding it
    private var filterBarWidth: CGFloat {
        let count = CGFloat(ProfileNoteFilter.allCases.count)
        return UIScreen.main.bounds.width / count - 16
    }
    
    @Namespace var animation
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 4) {
                            // this v stack is for bio and stats
                            VStack(alignment: .leading, spacing: 4) {
                                // this is for full name and username
                                Text("User name")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                
                                Text("username1")
                                    .font(.subheadline)
                            }
                            Text("Bio goes here")
                                .font(.footnote)
                            
                            Text("2 followers")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        CircularProfileImageView()
                    }
                    
                    Button {
                        
                    } label: {
                        Text("Follow")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 352, height: 32)
                            .background(.black)
                            .cornerRadius(8)
                    }
                    
                    // user content list view
                    
                    VStack {
                        HStack {
                            ForEach(ProfileNoteFilter.allCases) {
                                filter in
                                VStack {
                                    Text(filter.title)
                                        .font(.subheadline)
                                        .fontWeight(selectedFilter == filter ? .semibold: .regular)
                                    
                                    if selectedFilter == filter {
                                        Rectangle()
                                            .foregroundColor(.black)
                                            .frame(width: filterBarWidth, height: 1)
                                            .matchedGeometryEffect(id: "item", in: animation)
                                    } else {
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: filterBarWidth, height: 1)
                                    }
                                }
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        selectedFilter = filter
                                    }
                                }
                            }
                        }
                        LazyVStack {
                            ForEach(0 ... 10, id: \.self) { note in NoteCell()
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        AuthService.shared.signOut()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }

                }
            }
            .padding(.horizontal)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

