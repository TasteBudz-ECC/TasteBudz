//
//  AuthService.swift
//  TasteBudz
//
//  Created by student on 11/30/23.
//

import Firebase


class AuthService {
    
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do  {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            print("DEBUG: created user \(result.user.uid)")
        } catch {
            print("DEBUG: FAILED TO CREATE USER WITH ERROR \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String, fullname: String, username: String) async throws {
        do  {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            print("DEBUG: created user \(result.user.uid)")
        } catch {
            print("DEBUG: FAILED TO CREATE USER WITH ERROR \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut() // signs out user on backend
        self.userSession = nil // this removes user session locally and updates routing
    }
    
}
