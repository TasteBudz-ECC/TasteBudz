//
//  ContentActionButtonView.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import SwiftUI

struct ContentActionButtonView: View {
    @ObservedObject var viewModel: ContentActionButtonViewModel
    @State private var showReplySheet = false
    
    private var didLike: Bool {
        return viewModel.note?.didLike ?? false
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(spacing: 16) {
                Button {
                    handleLikeTapped()
                } label: {
                    Image(systemName: didLike ? "heart.fill" : "heart")
                        .foregroundColor(didLike ? .red : Color.theme.primaryText)
                }
                
                Button {
                    showReplySheet.toggle()
                } label: {
                    Image(systemName: "bubble.right")
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "arrow.rectanglepath")
                        .resizable()
                        .frame(width: 18, height: 16)
                }
                
                Button {
                    
                } label: {
                    Image(systemName: "paperplane")
                        .imageScale(.small)
                }

            }
            .foregroundStyle(Color.theme.primaryText)
            
            HStack(spacing: 4) {
                if let note = viewModel.note {
                    if note.replyCount > 0 {
                        Text("\(note.replyCount) replies")
                    }
                    
                    if note.replyCount > 0 && note.likes > 0 {
                        Text("-")
                    }
                    
                    if note.likes > 0 {
                        Text("\(note.likes) likes")
                    }
                }
            }
            .font(.caption)
            .foregroundColor(.gray)
            .padding(.vertical, 4)
        }
        .sheet(isPresented: $showReplySheet) {
            if let note = viewModel.note {
                NoteReplyView(note: note)
            }
        }
    }
    
    private func handleLikeTapped() {
        Task {
            if didLike {
                try await viewModel.unlikeNote()
            } else {
                try await viewModel.likeNote()
            }
        }
    }
}

struct ContentActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ContentActionButtonView(viewModel: ContentActionButtonViewModel(contentType: .note(dev.note)))
    }
}
