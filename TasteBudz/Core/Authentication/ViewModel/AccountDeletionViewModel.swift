//
//  AccountDeletionViewModel.swift
//  TasteBudz
//
//  Created by student on 12/12/23.
//
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class AccountDeletionViewModel: ObservableObject {
    func deleteUser() {
        guard let currentUser = Auth.auth().currentUser else {
            print("User is not authenticated")
            return
        }

        let userId = currentUser.uid
        
        let firestore = Firestore.firestore()
        let usersRef = firestore.collection("users").document(userId)
        
        // Begin a batched write to ensure atomicity in Firestore deletions
        firestore.runTransaction({ (transaction, errorPointer) -> Any? in
            transaction.deleteDocument(usersRef)
            return nil
        }) { (_, error) in
            if let error = error {
                print("Error deleting user data from Firestore: \(error.localizedDescription)")
                return
            }
            
            print("Deleted user data from Firestore")
            
            // Delete user images from Firebase Storage based on different paths
            self.deleteImages(for: .profile, userId: userId)
            self.deleteImages(for: .note, userId: userId)
            
            // Finally, delete the user account from Firebase Authentication
            currentUser.delete { error in
                if let error = error {
                    print("Error deleting user account: \(error.localizedDescription)")
                    return
                }
                
                print("Account deleted")
            }
        }
    }
    
    private func deleteImages(for uploadType: UploadType, userId: String) {
        let storageRef = Storage.storage().reference().child(uploadType == .profile ? "profile_images" : "post_images").child(userId)
        
        storageRef.delete { error in
            if let error = error {
                print("Error deleting \(uploadType) image from Storage: \(error.localizedDescription)")
                return
            }
            
            print("Deleted \(uploadType) image from Storage")
        }
    }
}

