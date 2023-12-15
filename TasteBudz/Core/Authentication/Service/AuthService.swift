//
//  AuthService.swift
//  TasteBudz
//
//  Created by student on 11/30/23.
//

import Firebase
import FirebaseAuth

class AuthService {
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        Task { try await UserService.shared.fetchCurrentUser() }
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await UserService.shared.fetchCurrentUser()
        } catch {
            print("DEBUG: Failed to login with error \(error.localizedDescription)")
            throw error
        }
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            try await uploadUserData(email: email, fullname: fullname, username: username, id: result.user.uid)
        } catch {
            print("DEBUG: Failed to login with error \(error.localizedDescription)")
            throw error
        }
    }
    
    @MainActor
    private func uploadUserData(email: String, fullname: String, username: String, id: String) async throws {
        let user = User(fullname: fullname, email: email, username: username.lowercased(), id: id)
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        try await FirestoreConstants.UserCollection.document(id).setData(encodedUser)
        UserService.shared.currentUser = user
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    func sendPasswordResetEmail(toEmail email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            print("DEBUG: Failed to send email with error \(error.localizedDescription)")
            throw error
        }
        
    }
    
    @MainActor
    func deleteUser() async throws {
        guard let currentUser = Auth.auth().currentUser else { return }

        do {
            // Refresh the user's token asynchronously
            try await currentUser.getIDTokenResult(forcingRefresh: true)
            
            // Perform actions before deletion (if needed)
            
            // Delete user data from Firestore
            try await FirestoreConstants.UserCollection.document(currentUser.uid).delete()
            
            // Delete the user from Firebase Authentication
            try await currentUser.delete()
            
            // Set userSession to nil after deletion
            self.userSession = nil
        } catch {
            print("DEBUG: Failed to delete user with error \(error.localizedDescription)")
            throw error
        }
    }

        
        // ... existing code

//    func deleteAccount() async -> Bool {
//        guard let user = Auth.auth().currentUser else { return false }
//        guard let lastSignInDate = user.metadata.lastSignInDate else { return false }
//        let needsReauth = !lastSignInDate.isWithinPast(minutes: 5)
//        do {
//            try await user?.delete()
//            errorMessage = ""
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//
//        return false
//    }
}

//extension Date {
//    func isWithinPast(minutes: Int) -> Bool {
//        let now = Date.now
//        let timeAgo = Date.now.addingTimeInterval(-1 * TimeInterval(60 * minutes))
//        let range = timeAgo...now
//        return range.contains(self)
//    }
//}
