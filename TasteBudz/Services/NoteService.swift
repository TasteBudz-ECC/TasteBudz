//
//  NoteService.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct NoteService {
    static func uploadNote(_ note: Note) async throws {
        guard let noteData = try? Firestore.Encoder().encode(note) else { return }
        let ref = try await FirestoreConstants.NotesCollection.addDocument(data: noteData)
        try await updateUserFeedsAfterPost(noteId: ref.documentID)
    }
    
    static func fetchNotes() async throws -> [Note] {
        let snapshot = try await FirestoreConstants
            .NotesCollection
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: Note.self) })
    }
    
    static func fetchUserNotes(uid: String) async throws -> [Note] {
        let query = FirestoreConstants.NotesCollection.whereField("ownerUid", isEqualTo: uid)
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: Note.self) })
    }
    
    static func fetchNote(noteId: String) async throws -> Note {
        let snapshot = try await FirestoreConstants.NotesCollection.document(noteId).getDocument()
        let note = try snapshot.data(as: Note.self)
        return note
    }
}

// MARK: - Replies

extension NoteService {
    static func replyToNote(_ note: Note, replyText: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let reply = NoteReply(
            noteId: note.id,
            replyText: replyText,
            noteReplyOwnerUid: currentUid,
            noteOwnerUid: note.ownerUid,
            timestamp: Timestamp()
        )
        
        guard let data = try? Firestore.Encoder().encode(reply) else { return }
        try await FirestoreConstants.RepliesCollection.document().setData(data)
        try await FirestoreConstants.NotesCollection.document(note.id).updateData([
            "replyCount": note.replyCount + 1
        ])
        
        ActivityService.uploadNotification(toUid: note.ownerUid, type: .reply, noteId: note.id)
    }
    
    static func fetchNoteReplies(forNote note: Note) async throws -> [NoteReply] {
        let snapshot = try await FirestoreConstants.RepliesCollection.whereField("noteId", isEqualTo: note.id).getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: NoteReply.self) })
    }
    
    static func fetchNoteReplies(forUser user: User) async throws -> [NoteReply] {
       let snapshot = try await  FirestoreConstants
            .RepliesCollection
            .whereField("noteReplyOwnerUid", isEqualTo: user.id)
            .getDocuments()
        
        var replies = snapshot.documents.compactMap({ try? $0.data(as: NoteReply.self) })
        
        for i in 0 ..< replies.count {
            replies[i].replyUser = user
        }
        
        return replies
    }
}

// MARK: - Likes

extension NoteService {
    static func likeNote(_ note: Note) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirestoreConstants.NotesCollection.document(note.id).collection("note-likes").document(uid).setData([:])
        async let _ = try await FirestoreConstants.NotesCollection.document(note.id).updateData(["likes": note.likes + 1])
        async let _ = try await FirestoreConstants.UserCollection.document(uid).collection("user-likes").document(note.id).setData([:])
        
        ActivityService.uploadNotification(toUid: note.ownerUid, type: .like, noteId: note.id)
    }
    
    static func unlikeNote(_ note: Note) async throws {
        guard note.likes > 0 else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirestoreConstants.NotesCollection.document(note.id).collection("note-likes").document(uid).delete()
        async let _ = try await FirestoreConstants.UserCollection.document(uid).collection("user-likes").document(note.id).delete()
        async let _ = try await FirestoreConstants.NotesCollection.document(note.id).updateData(["likes": note.likes - 1])
        
        async let _ = try await ActivityService.deleteNotification(toUid: note.ownerUid, type: .like, noteId: note.id)
    }
    
    static func checkIfUserLikedNote(_ note: Note) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        
        let snapshot = try await FirestoreConstants.UserCollection.document(uid).collection("user-likes").document(note.id).getDocument()
        return snapshot.exists
    }
}

// MARK: - Feed Updates
// old version
extension NoteService {
    private static func updateUserFeedsAfterPost(noteId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // Fetch first-degree friends
        let firstDegreeFriends = try await UserService.shared.fetchFirstDegreeFriends(forUserID: uid)

        // Set to keep track of all unique users who need feed updates (to avoid duplicates)
        var usersToUpdate = Set(firstDegreeFriends)

        // Fetch second-degree friends
        for friendID in firstDegreeFriends {
            let secondDegreeFriends = try await UserService.fetchSecondDegreeFriends(forUserID: friendID)
            usersToUpdate.formUnion(secondDegreeFriends)
        }
        
        // Update each user's feed
        for userID in usersToUpdate {
            try await FirestoreConstants
                .UserCollection
                .document(userID)
                .collection("user-feed")
                .document(noteId).setData([:])
        }
        
        // Update the user's own feed
        try await FirestoreConstants.UserCollection.document(uid).collection("user-feed").document(noteId).setData([:])
    }
}

// this new version uses the populate network func to show gathering posts from the user's network! i dont really see a difference between this func and the other one so i leave it commented out for testing purposes

//extension NoteService {
//    private static func updateUserFeedsAfterPost(noteId: String) async throws {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        // Fetch the combined network (first and second-degree friends)
//        let combinedNetwork = await populateNetwork(forUserID: uid)
//
//        // Update each user's feed in the combined network
//        for userID in combinedNetwork {
//            try await FirestoreConstants
//                .UserCollection
//                .document(userID)
//                .collection("user-feed")
//                .document(noteId).setData([:])
//        }
//
//        // Update the user's own feed
//        try await FirestoreConstants.UserCollection.document(uid).collection("user-feed").document(noteId).setData([:])
//    }
//}
