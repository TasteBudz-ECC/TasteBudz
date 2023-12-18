//
//  ProfileViewModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation
import Combine
import SwiftUI
import PhotosUI
import Firebase

@MainActor
class CurrentUserProfileViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var currentUser: User?
    @Published var notes = [Note]()
    @Published var replies = [NoteReply]()
    
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }
    @Published var profileImage: Image?
    @Published var bio = ""
    
    private var uiImage: UIImage?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init() {
        UserService.shared.setupRealtimeUpdates()
        setupSubscribers()
        loadUserData()
    }
    
    // MARK: - User Data

    func loadUserData() {
        Task {
            currentUser = await UserService.shared.currentUser
            bio = currentUser?.bio ?? ""
        }
    }

    func updateUserData() async throws {
        guard let userId = currentUser?.id else { return }
        var data: [String: Any] = [:]

        if !bio.isEmpty, currentUser?.bio ?? "" != bio {
            data["bio"] = bio
        }

        if let uiImage = uiImage {
            let imageUrl = try await ImageUploader.uploadImage(image: uiImage, type: .profile)
            data["profileImageUrl"] = imageUrl
        }

        try await UserService.shared.updateUserProfile(userId: userId, data: data)
        // Update currentUser after successful update
        currentUser = try await UserService.fetchUser(withUid: userId)
    }
//    func refreshUserData() async {
//        currentUser = await UserService.shared.currentUser
//            // This will update the user's friends and friend network counts if they have changed
//        }
//
//        // Call this method when you know there's been a change in the user's friends or friend network
//        func updateFriendshipData() async {
//            await refreshUserData()
//        }

    // MARK: - Subscribers

    @MainActor
    private func setupSubscribers() {
        UserService.shared.$currentUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.currentUser = user
                self?.bio = user?.bio ?? ""
                // Load profile image from URL if needed
            }
            .store(in: &cancellables)
    }

    // MARK: - Image Loading

    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
    func updateProfileImage(_ uiImage: UIImage) async throws {
        let imageUrl = try await ImageUploader.uploadImage(image: uiImage, type: .profile)
        currentUser?.profileImageUrl = imageUrl
    }
}
