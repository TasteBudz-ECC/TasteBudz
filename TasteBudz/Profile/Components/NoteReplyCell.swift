//
//  NoteReplyCell.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import SwiftUI

struct NoteReplyCell: View {
    let reply: NoteReply
    @State private var noteViewSize: CGFloat = 24
    @State private var showReplySheet = false
    
    private var note: Note? {
        return reply.note
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if let note = note {
                HStack(alignment: .top) {
                    VStack {
                        CircularProfileImageView(user: note.user, size: .small)
                        
                        Rectangle()
                            .frame(width: 2, height: noteViewSize - 24)
                            .foregroundColor(Color(.systemGray4))
                    }
                    
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(note.user?.username ?? "")
                                .fontWeight(.semibold)
                            
                            Text(note.caption)
                            
                        }
                        .font(.footnote)
                        
                        ContentActionButtonView(viewModel: ContentActionButtonViewModel(contentType: .note(note)))
                            .padding(.bottom, 4)
                    }
                    
                    Spacer()
                }
            }
            
            HStack(alignment: .top) {
                CircularProfileImageView(user: reply.replyUser, size: .small)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(reply.replyUser?.username ?? "")
                        .fontWeight(.semibold)
                    
                    Text(reply.replyText)
                }
                .font(.footnote)

            }
            
            Divider()
        }
        .onAppear {
            setNoteHeight()
        }
    }
    
    func setNoteHeight() {
        guard let note = note else { return }
        let imageHeight: CGFloat = 40
        let captionHeight = note.caption.sizeUsingFont(usingFont: UIFont.systemFont(ofSize: 12))
        let actionButtonViewHeight: CGFloat = 40
        self.noteViewSize = imageHeight + captionHeight.height + actionButtonViewHeight
    }
}

struct NoteReplyCell_Previews: PreviewProvider {
    static var previews: some View {
        NoteReplyCell(reply: dev.reply)
    }
}

