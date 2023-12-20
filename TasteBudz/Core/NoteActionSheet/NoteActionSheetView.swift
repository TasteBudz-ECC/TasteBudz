//
//  NoteActionSheetView.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import SwiftUI

struct NoteActionSheetView: View {
    let note: Note
    @Binding var selectedAction: NoteActionSheetOptions?
    
    var body: some View {
        List {
            Section {
                NoteActionSheetRowView(option: .report, selectedAction: $selectedAction)
                    .foregroundColor(.red)
            }
        }
        .presentationDetents([.medium])
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
        NoteActionSheetView(note: dev.note, selectedAction: .constant(.report))
    }
}
