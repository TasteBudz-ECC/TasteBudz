//
//  CreateNoteViewModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation
import Firebase

class CreateNoteViewModel: ObservableObject {
    
    @Published var caption = ""
    
    func uploadNote() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let note = Note(
            ownerUid: uid,
            caption: caption,
            timestamp: Timestamp(),
            likes: 0,
            replyCount: 0
        )
        try await NoteService.uploadNote(note)
    }
}
