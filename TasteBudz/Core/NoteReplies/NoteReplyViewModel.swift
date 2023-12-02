//
//  NoteReplyViewModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation

class NoteReplyViewModel: ObservableObject {
    
    func uploadNoteReply(toNote note: Note, replyText: String) async throws {
        try await NoteService.replyToNote(note, replyText: replyText)
    }
}
