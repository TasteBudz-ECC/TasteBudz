//
//  ContentActionButtonViewModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation
import FirebaseFirestore

@MainActor
class ContentActionButtonViewModel: ObservableObject {
    @Published var note: Note?
    @Published var reply: NoteReply?
    
    init(contentType: NoteViewConfig) {
        switch contentType {
        case .note(let note):
            self.note = note
            Task { await checkNoteAndUserStatus() }
            
        case .reply(let reply):
            self.reply = reply
            // If needed, add similar logic for replies
        }
    }
    
    func likeNote() async throws {
        guard let note = note, await isUserActive(uid: note.ownerUid) else { return }
        
        try await NoteService.likeNote(note)
        self.note?.didLike = true
        self.note?.likes += 1
    }
    
    func unlikeNote() async throws {
        guard let note = note, await isUserActive(uid: note.ownerUid) else { return }

        try await NoteService.unlikeNote(note)
        self.note?.didLike = false
        self.note?.likes -= 1
    }
    
    private func checkNoteAndUserStatus() async {
        guard let note = note else { return }

        do {
            let didLike = try await NoteService.checkIfUserLikedNote(note)
            let userIsActive = await isUserActive(uid: note.ownerUid)
            if didLike && userIsActive {
                self.note?.didLike = true
            }
        } catch {
            print("Error checking if user liked note: \(error)")
            // Handle the error appropriately
        }
    }
    
    private func isUserActive(uid: String) async -> Bool {
        do {
            _ = try await UserService.fetchUser(withUid: uid)
            return true
        } catch {
            print("User not found or inactive")
            return false
        }
    }
}
