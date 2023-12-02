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
    @State private var isFollowed = false
    @Binding var selectedAction: NoteActionSheetOptions?
    
    var body: some View {
        List {
            Section {
                if isFollowed {
                    NoteActionSheetRowView(option: .unfollow, selectedAction: $selectedAction)
                }
                
                NoteActionSheetRowView(option: .mute, selectedAction: $selectedAction)
            }
            
            Section {
                NoteActionSheetRowView(option: .report, selectedAction: $selectedAction)
                    .foregroundColor(.red)
                
                if !isFollowed {
                    NoteActionSheetRowView(option: .block, selectedAction: $selectedAction)
                        .foregroundColor(.red)
                }
            }
        }
        
        .onAppear {
            Task {
                if let user = note.user {
                    let isFollowed = await UserService.checkIfUserIsFollowed(user)
                    self.isFollowed = isFollowed
                    height += isFollowed ? 32 : 0
                }
            }
        }
        .presentationDetents([.height(height)])
        .presentationDragIndicator(.visible)
        .cornerRadius(10)
        .font(.footnote) //
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
        NoteActionSheetView(note: dev.note, selectedAction: .constant(.unfollow))
    }
}
