//
//  AccountDeletionViewModel.swift
//  TasteBudz
//
//  Created by student on 12/12/23.
//
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class AccountDeletionViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var errorMessage: String?

    private let firestore = Firestore.firestore()
    private let storage = Storage.storage()

    func deleteUser() async {
        guard let currentUser = Auth.auth().currentUser else {
            errorMessage = "User is not authenticated."
            showAlert = true
            return
        }

        let userId = currentUser.uid
        do {
            try await deleteFirestoreData(for: userId)
            try await deleteStorageData(for: userId)
            await reauthenticateAndDeleteAccount(currentUser: currentUser)
        } catch {
            errorMessage = "Account deletion failed: \(error.localizedDescription)"
            showAlert = true
        }
    }

    private func deleteFirestoreData(for userId: String) async throws {
        let usersRef = firestore.collection("users").document(userId)
        try await firestore.runTransaction { transaction, errorPointer in
            transaction.deleteDocument(usersRef)
        }
    }

    private func deleteStorageData(for userId: String) async throws {
        let profileImagesRef = storage.reference().child("profile_images").child(userId)
        let postImagesRef = storage.reference().child("post_images").child(userId)
        try await profileImagesRef.delete()
        try await postImagesRef.delete()
    }

    // The reauthentication process will be handled in the UI layer
    @MainActor
    func reauthenticateAndDeleteAccount(currentUser: FirebaseAuth.User) async {
        // The UI layer will call this function after successful reauthentication
        do {
            try await currentUser.delete()
            // Handle successful account deletion, e.g., navigate to a different view.
        } catch {
            errorMessage = "Error deleting user account: \(error.localizedDescription)"
            showAlert = true
        }
    }
}

