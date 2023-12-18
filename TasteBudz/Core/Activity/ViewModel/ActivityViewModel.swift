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
        didSet { updateFilteredNotifications() }
    }

    private var allNotifications = [ActivityModel]()

    init() {
        Task { await updateNotifications() }
    }

    private func fetchNotificationData() async {
        self.isLoading = true
        do {
            let fetchedNotifications = try await ActivityService.fetchUserActivity()
            self.allNotifications = fetchedNotifications
            updateFilteredNotifications()
        } catch {
            // Handle errors appropriately
            print("Error fetching notifications: \(error)")
        }
        self.isLoading = false
    }

    private func updateNotifications() async {
        await fetchNotificationData()

        await withThrowingTaskGroup(of: Void.self, body: { group in
            for notification in allNotifications {
                group.addTask {
                    try? await self.updateNotificationMetadata(notification: notification)
                }
            }
        })
    }

    private func updateNotificationMetadata(notification: ActivityModel) async throws {
        let activeUsersSnapshot = try await Firestore.firestore().collection("users").getDocuments()
        let activeUserIds = activeUsersSnapshot.documents.compactMap { $0.documentID }

        guard let indexOfNotification = notifications.firstIndex(where: { $0.id == notification.id }) else { return }

        if activeUserIds.contains(notification.senderUid) {
            var notificationUser = try await UserService.fetchUser(withUid: notification.senderUid)

            switch notification.type {
            case .friendAdded:
                let isFriends = await UserService.shared.checkIfUserIsFriends(notificationUser)
                notificationUser.isFriends = isFriends

            case .friendNetworkUpdated:
                let isInFriendNetwork = await UserService.shared.isUserInFriendNetwork(notificationUser)
                notificationUser.isInFriendNetwork = isInFriendNetwork

            default:
                break
            }

            self.notifications[indexOfNotification].user = notificationUser

            if let noteId = notification.noteId {
                let noteSnapshot = try await FirestoreConstants.NotesCollection.document(noteId).getDocument()
                self.notifications[indexOfNotification].note = try? noteSnapshot.data(as: Note.self)
            }
        } else {
            self.notifications.remove(at: indexOfNotification)
        }
    }

    private func updateFilteredNotifications() {
        switch selectedFilter {
        case .all:
            self.notifications = allNotifications
        case .replies:
            self.notifications = allNotifications.filter({ $0.type == .reply })
        case .friends:
            self.notifications = allNotifications.filter({ $0.type == .friendAdded })
        case .friendNetwork:
            self.notifications = allNotifications.filter({ $0.type == .friendNetworkUpdated })
        }
    }
}


// Ensure you have these cases in your ActivityFilterViewModel
//enum ActivityFilterViewModel {
//    case all
//    case replies
//    case friends
//    case friendNetwork
//    // Other cases if needed
//}




