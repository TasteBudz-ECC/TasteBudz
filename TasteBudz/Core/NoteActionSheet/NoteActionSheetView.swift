//
//  NoteActionSheetView.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import SwiftUI

struct NoteActionSheetView: View {
    let note: Note
    @State private var height: CGFloat = 200
    @State private var isFriends = false
    @Binding var selectedAction: NoteActionSheetOptions?
    
    var body: some View {
        List {
            Section {
                if isFriends {
                    NoteActionSheetRowView(option: .unfriend, selectedAction: $selectedAction)
                } else {
                    NoteActionSheetRowView(option: .addFriend, selectedAction: $selectedAction)
                }
                
                NoteActionSheetRowView(option: .report, selectedAction: $selectedAction)
            }
            
//            Section {
//                NoteActionSheetRowView(option: .block, selectedAction: $selectedAction)
//                    .foregroundColor(.red)
//            }
        }
        .onAppear {
            Task {
                if let user = note.user {
                    self.isFriends = await UserService.shared.checkIfUserIsFriends(user)
                    self.height += self.isFriends ? 32 : 0
                }
            }
        }
        .presentationDetents([.height(height)])
        .presentationDragIndicator(.visible)
        .cornerRadius(10)
        .font(.footnote)
    }
}

struct NoteActionSheetRowView: View {
    let option: NoteActionSheetOptions
    @Environment(\.dismiss) var dismiss
    @Binding var selectedAction: NoteActionSheetOptions?
    
    var body: some View {
        HStack {
            Text(option.title)
                .font(.footnote)
            
            Spacer()
        }
        .background(Color.theme.primaryBackground)
        .onTapGesture {
            selectedAction = option
            dismiss()
        }
    }
}

struct NoteActionSheetView_Previews: PreviewProvider {
    static var previews: some View {
        NoteActionSheetView(note: dev.note, selectedAction: .constant(.unfriend))
    }
}
