//
//  NoteDetailsViewModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation
import Firebase

@MainActor
class NoteDetailsViewModel: ObservableObject {
    @Published var note: Note
    @Published var replies = [NoteReply]()
    
    init(note: Note) {
        self.note = note
        setNoteUserIfNecessary()
        Task { try await fetchNoteReplies() }
    }
    
    private func setNoteUserIfNecessary() {
        guard note.user == nil else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        if note.ownerUid == currentUid {
            note.user = UserService.shared.currentUser
        }
    }
    
    func fetchNoteReplies() async throws {
        self.replies = try await NoteService.fetchNoteReplies(forNote: note)
        
        await withThrowingTaskGroup(of: Void.self, body: { group in
            for reply in replies {
                group.addTask { try await self.fetchUserData(forReply: reply) }
            }
        })
    }
    
    private func fetchUserData(forReply reply: NoteReply) async throws {
        guard let replyIndex = replies.firstIndex(where: { $0.id == reply.id }) else { return }
        
        async let user = UserService.fetchUser(withUid: reply.noteReplyOwnerUid)
        self.replies[replyIndex].replyUser = try await user
    }
}
