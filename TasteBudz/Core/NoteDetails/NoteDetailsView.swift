//
//  NoteDetailsView.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import SwiftUI

struct NoteDetailsView: View {
    @State private var showReplySheet = false
    @StateObject var viewModel: NoteDetailsViewModel
    
    private var note: Note {
        return viewModel.note
    }
    
    init(note: Note) {
        self._viewModel = StateObject(wrappedValue: NoteDetailsViewModel(note: note))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    CircularProfileImageView(user: note.user, size: .small)
                    
                    Text(note.user?.username ?? "")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text("12m")
                        .font(.caption)
                        .foregroundStyle(Color(.systemGray3))
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color(.darkGray))
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(note.caption)
                        .font(.subheadline)
                    
                    ContentActionButtonView(viewModel: ContentActionButtonViewModel(contentType: .note(note)))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Divider()
                .padding(.vertical)
            
            LazyVStack(spacing: 16) {
                ForEach(viewModel.replies) { reply in
                    NoteCell(config: .reply(reply))
                }
            }
        }
        .sheet(isPresented: $showReplySheet, content: {
            NoteReplyView(note: note)
        })
        .padding()
        .navigationTitle("Note")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NoteDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NoteDetailsView(note: dev.note)
    }
}

