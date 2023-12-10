//
//  FeedViewModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation
import Firebase

@MainActor
class FeedViewModel: ObservableObject {
    @Published var notes = [Note]()
    @Published var isLoading = false
    
    init() {
        Task { try await fetchNotes() }
    }
    
    private func fetchNoteIDs() async -> [String] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        isLoading = true
        
        let snapshot = try? await FirestoreConstants
            .UserCollection
            .document(uid)
            .collection("user-feed")
            .getDocuments()
        
        return snapshot?.documents.map({ $0.documentID }) ?? []
    }
    
    func fetchNotes() async throws {
        let noteIDs = await fetchNoteIDs()

        try await withThrowingTaskGroup(of: Note.self, body: { group in
            var notes = [Note]()

            for id in noteIDs {
                group.addTask { return try await NoteService.fetchNote(noteId: id) }
            }

            for try await note in group {
                notes.append(try await fetchNoteUserData(note: note))
            }

            self.notes = notes.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
            isLoading = false
        })
    }
    
    private func fetchNoteUserData(note: Note) async throws -> Note {
        var result = note
    
        async let user = try await UserService.fetchUser(withUid: note.ownerUid)
        result.user = try await user
        
        return result
    }
    
    private func getUserRestaurantsFromUID() async -> [String] {
        do {
            guard let uid = Auth.auth().currentUser?.uid else { return [] }
            
            let querySnapshot = try await Firestore
                .firestore()
                .collection("restaurants")
                .whereField("userID", isEqualTo: uid)
                .getDocuments()
            
            let restaurantIDs = querySnapshot.documents.map { $0.documentID }
            return restaurantIDs
        } catch {
            print("Error fetching user restaurants: \(error)")
            return []
        }
    }

}
