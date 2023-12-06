//
//  UserContentListViewModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation

@MainActor
class UserContentListViewModel: ObservableObject {
    @Published var notes = [Note]()
    @Published var replies = [NoteReply]()
    
    private let user: User
    
    init(user: User) {
        self.user = user
        Task { try await fetchUserNotes() }
        Task { try await fetchUserReplies() }
    }
    
    func fetchUserNotes() async throws {
        var userNotes = try await NoteService.fetchUserNotes(uid: user.id)
        
        for i in 0 ..< userNotes.count {
            userNotes[i].user = self.user
        }
        self.notes = userNotes
    }
    
    func fetchUserReplies() async throws {
        self.replies = try await NoteService.fetchNoteReplies(forUser: user)
        try await fetchReplyMetadta()
    }
    
    private func fetchReplyMetadta() async throws {
        await withThrowingTaskGroup(of: Void.self, body: { group in
            for reply in self.replies {
                group.addTask { try await self.fetchReplyNoteData(reply: reply) }
            }
        })
    }
    
    private func fetchReplyNoteData(reply: NoteReply) async throws {
        guard let replyIndex = replies.firstIndex(where: { $0.id == reply.id }) else { return }
        
        async let note = try await NoteService.fetchNote(noteId: reply.noteId)
        
        let noteOwnerUid = try await note.ownerUid
        async let user = try await UserService.fetchUser(withUid: noteOwnerUid)
        
        var noteCopy = try await note
        noteCopy.user = try await user
        replies[replyIndex].note = noteCopy
    }
    
    func noContentText(filter: ProfileNoteFilterViewModel) -> String {
        let name = user.isCurrentUser ? "You" : user.username
        let nextWord = user.isCurrentUser ? "haven't" : "hasn't"
        let contentType = filter == .notes ? "notes" : "replies"
        
        return "\(name) \(nextWord) posted any \(contentType) yet."
    }
}
