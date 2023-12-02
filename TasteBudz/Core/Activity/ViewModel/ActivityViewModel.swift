//
//  ActivityViewModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import SwiftUI

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
        guard let indexOfNotification = notifications.firstIndex(where: { $0.id == notification.id }) else { return }
        
        async let notificationUser = try await UserService.fetchUser(withUid: notification.senderUid)
        var user = try await notificationUser
        
        if notification.type == .follow {
            async let isFollowed = await UserService.checkIfUserIsFollowedWithUid(notification.senderUid)
            user.isFollowed = await isFollowed
        }
        
        self.notifications[indexOfNotification].user = user
        
        if let noteId = notification.noteId {
            async let noteSnapshot = await FirestoreConstants.NotesCollection.document(noteId).getDocument()
            self.notifications[indexOfNotification].note = try? await noteSnapshot.data(as: Note.self)
        }
    }
}

