//
//  CurrentUserProfileContentVIew.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import SwiftUI

enum CurrentUserProfileSheetConfig: Identifiable {
    case editProfile
    case userRelations
    
    var id: Int { return hashValue }
}

struct CurrentUserProfileContentView: View {
    @StateObject var viewModel = CurrentUserProfileViewModel()
    @State private var selectedThreadFilter: ProfileNoteFilterViewModel = .notes
    @State private var sheetConfig: CurrentUserProfileSheetConfig?
    
    private var user: User? {
        return viewModel.currentUser
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            HStack {
                Spacer()
                
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .foregroundColor(Color.theme.primaryText)
                }
            }
            .padding(.bottom)
            
            VStack(spacing: 20) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user?.fullname ?? "")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text(user?.username ?? "")
                                .font(.subheadline)
                        }
                        
                        if let bio = user?.bio {
                            Text(bio)
                                .font(.footnote)
                        }
                        
                        Button {
                            sheetConfig = .userRelations
                        } label: {
                            Text("\(viewModel.currentUser?.stats?.followersCount ?? 0) followers")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }

                    }
                    
                    Spacer()
                    
                    CircularProfileImageView(user: user, size: .medium)
                }
                
                HStack {
                    Button {
                        sheetConfig = .editProfile
                    } label: {
                        Text("Edit Profile")
                            .foregroundStyle(Color.theme.primaryText)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 175, height: 32)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            }
                    }
                    
                    Button {
                        
                    } label: {
                        Text("Share Profile")
                            .foregroundStyle(Color.theme.primaryText)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 175, height: 32)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            }
                    }
                }
                
                if let user = user {
                    UserContentListView(selectedFilter: $selectedThreadFilter, user: user)
                }
            }
        }
        .sheet(item: $sheetConfig, content: { config in
            switch config {
            case .editProfile:
                EditProfileView()
                    .environmentObject(viewModel)
            case .userRelations:
                if let user {
                    UserRelationsView(user: user)
                }
            }
        })
    }
}

struct CurrentUserProfileContentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserProfileContentView()
    }
}
