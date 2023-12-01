//
//  UserService.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Firebase
import FirebaseFirestoreSwift

class UserService {
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    init() {
        Task { try await fetchCurrentUser() }
    }
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        self.currentUser = user
    }
    
    
    // this function is to fetch ALL users in search
    // im thinking we might not need it because we are looking to only expand up to mutuals but would like to know what you guys think :)
    static func fetchUsers() async throws -> [User] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        let users = snapshot.documents.compactMap( { try? $0.data(as: User.self) })
        return users.filter({ $0.id != currentUid })
    }
    
    // this function is so that once a user logs out and another one logs in, it displays the current user
    func reset() {
        self.currentUser = nil
    }
}

