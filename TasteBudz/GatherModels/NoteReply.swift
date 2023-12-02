//
//  NoteReply.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import FirebaseFirestoreSwift
import Firebase

struct NoteReply: Identifiable, Codable {
    @DocumentID private var replyId: String?
    let noteId: String
    let replyText: String
    let noteReplyOwnerUid: String
    let noteOwnerUid: String
    let timestamp: Timestamp
    
    var note: Note?
    var replyUser: User?
    
    var id: String {
        return replyId ?? NSUUID().uuidString
    }
}
