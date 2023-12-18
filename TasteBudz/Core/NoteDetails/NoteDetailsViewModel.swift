//
//  NoteDetailsViewModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import SwiftUI
import Firebase

@MainActor
class NoteDetailsViewModel: ObservableObject {
    @Published var note: Note
    @Published var replies = [NoteReply]()
    
    init(note: Note) {
        self.note = note
        Task { await updateReplies() }
    }
    
    private func updateReplies() async {
        do {
            let fetchedReplies = try await NoteService.fetchNoteReplies(forNote: note)
            await withThrowingTaskGroup(of: Void.self, body: { group in
                for reply in fetchedReplies {
                    group.addTask {
                        try await self.processReply(reply)
                    }
                }
            })
        } catch {
            print("Error fetching replies: \(error)")
        }
    }
    
    private func processReply(_ reply: NoteReply) async throws {
        do {
            let user = try await UserService.fetchUser(withUid: reply.noteReplyOwnerUid)
            await MainActor.run {
                self.replies.append(reply)
            }
        } catch {
            print("User not found or inactive, skipping reply.")
        }
    }
}
