//
//  ActivityViewModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import SwiftUI
import FirebaseFirestore

@MainActor
class ActivityViewModel: ObservableObject {
    @Published var notifications = [ActivityModel]()
    @Published var isLoading = false
    
    @Published var selectedFilter: ActivityFilterViewModel = .all {
        didSet {
            switch selectedFilter {
            case .all:
                self.notifications = temp
            case .replies:
                temp = notifications
                self.notifications = notifications.filter({ $0.type == .reply })
            }
        }
    }
    
    private var temp = [ActivityModel]()
    
    init() {
        Task { try await updateNotifications() }
    }
    
    private func fetchNotificationData() async throws {
        self.isLoading = true
        self.notifications = try await ActivityService.fetchUserActivity()
        self.isLoading = false
    }
    
    private func updateNotifications() async throws {
        try await fetchNotificationData()
        
        await withThrowingTaskGroup(of: Void.self, body: { group in
            for notification in notifications {
                group.addTask { try await self.updateNotificationMetadata(notification: notification) }
            }
        })
    }
    
    private func updateNotificationMetadata(notification: ActivityModel) async throws {
        // Fetch active user IDs from Firestore (replace this with your actual logic)
        let activeUsersSnapshot = try await Firestore.firestore().collection("users").getDocuments()
        let activeUserIds = activeUsersSnapshot.documents.compactMap { $0.documentID }
        
        guard let indexOfNotification = notifications.firstIndex(where: { $0.id == notification.id }) else { return }
        
        if activeUserIds.contains(notification.senderUid) {
            // User is active, proceed with updating metadata
            async let notificationUser = try await UserService.fetchUser(withUid: notification.senderUid)
            var user = try await notificationUser
            
            if notification.type == .friend {
                async let isFriends = await UserService.checkIfUserIsFriendWithUid(notification.senderUid)
                user.isFriends = await isFriends
            }
            
            self.notifications[indexOfNotification].user = user
            
            if let noteId = notification.noteId {
                async let noteSnapshot = await FirestoreConstants.NotesCollection.document(noteId).getDocument()
                self.notifications[indexOfNotification].note = try? await noteSnapshot.data(as: Note.self)
            }
        } else {
            // Remove notification if the user is not active
            self.notifications.remove(at: indexOfNotification)
            // Decrement the index to properly handle removal
            //             indexOfNotification -= 1 // Uncomment if needed in your implementation
        }
    }
}


