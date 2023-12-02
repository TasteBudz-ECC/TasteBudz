//
//  PreviewProvider.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import SwiftUI
import Firebase

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    var note = Note(
        ownerUid: NSUUID().uuidString,
        caption: "Here's to the crazy ones. The misfits. The rebels",
        timestamp: Timestamp(),
        likes: 247,
        imageUrl: "lewis-hamilton",
        replyCount: 67,
        user: User(
            fullname: "Lewis Hamilton",
            email: "lewis-hamilton@gmail.com",
            username: "lewis-hamilton",
            profileImageUrl: nil,
            id: NSUUID().uuidString
        )
    )
    
    var user = User(
        fullname: "Daniel Ricciardo",
        email: "daniel@gmail.com",
        username: "daniel-ricciardo",
        profileImageUrl: nil,
        id: NSUUID().uuidString
    )
    
    lazy var activityModel = ActivityModel(
        type: .like,
        senderUid: NSUUID().uuidString,
        timestamp: Timestamp(),
        user: self.user
    )
    
    lazy var reply = NoteReply(
        noteId: NSUUID().uuidString,
        replyText: "This is a test reply for preview purposes",
        noteReplyOwnerUid: NSUUID().uuidString,
        noteOwnerUid: NSUUID().uuidString,
        timestamp: Timestamp(),
        note: note,
        replyUser: user
    )
}
