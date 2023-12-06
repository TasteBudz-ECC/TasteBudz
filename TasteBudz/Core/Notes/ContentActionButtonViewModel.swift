//
//  ContentActionButtonViewModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation

@MainActor
class ContentActionButtonViewModel: ObservableObject {
    @Published var note: Note?
    @Published var reply: NoteReply?
    
    init(contentType: NoteViewConfig) {
        switch contentType {
        case .note(let note):
            self.note = note
            Task { try await checkIfUserLikedNote() }
            
        case .reply(let reply):
            self.reply = reply
        }
    }
    
    func likeNote() async throws {
        guard let note = note else { return }
        
        try await NoteService.likeNote(note)
        self.note?.didLike = true
        self.note?.likes += 1
    }
    
    func unlikeNote() async throws {
        guard let note = note else { return }

        try await NoteService.unlikeNote(note)
        self.note?.didLike = false
        self.note?.likes -= 1
    }
    
    func checkIfUserLikedNote() async throws {
        guard let note = note else { return }

        let didLike = try await NoteService.checkIfUserLikedNote(note)
        if didLike {
            self.note?.didLike = true
        }
    }
}
