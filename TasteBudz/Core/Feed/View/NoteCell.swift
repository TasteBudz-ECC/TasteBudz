//
//  NoteCell.swift
//  TasteBudz
//
//  Created by student on 11/29/23.
//
import SwiftUI
enum NoteViewConfig {
    case note(Note)
    case reply(NoteReply)
}

struct NoteCell: View {
    let config: NoteViewConfig
    @State private var showNoteActionSheet = false
    @State private var selectedNoteAction: NoteActionSheetOptions?
    @State private var isReportPopupPresented = false
    
    @State private var shouldShowReportPopup = false
    
    private var user: User? {
        switch config {
        case .note(let note):
            return note.user
        case .reply(let noteReply):
            return noteReply.replyUser
        }
    }
    
    private var caption: String {
        switch config {
        case .note(let note):
            return note.caption
        case .reply(let noteReply):
            return noteReply.replyText
        }
    }
    
    private var timestampString: String {
        switch config {
        case .note(let note):
            return note.timestamp.timestampString()
        case .reply(let noteReply):
            return noteReply.timestamp.timestampString()
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .top, spacing: 12) {
                    NavigationLink(destination: Text("Detail View")) {
                        CircularProfileImageView(user: user, size: .small)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(user?.username ?? "")
                                .font(.footnote)
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Text(timestampString)
                                .font(.caption)
                                .foregroundStyle(Color(.systemGray3))
                            
                            Button {
                                showNoteActionSheet.toggle()
                            } label: {
                                Image(systemName: "ellipsis")
                                    .foregroundStyle(Color(.darkGray))
                            }
                        }
                        
                        Text(caption)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                        
                        ContentActionButtonView(viewModel: ContentActionButtonViewModel(contentType: config))
                            .padding(.top, 12)
                    }
                }
                .actionSheet(isPresented: $showNoteActionSheet) {
                    ActionSheet(
                        title: Text("Options"),
                        buttons: [
                            .default(Text("Report")) {
                                selectedNoteAction = .report
                            },
                            .cancel()
                        ]
                    )
                }
                
                NavigationLink(destination: ReportPopupContentView(), isActive: $shouldShowReportPopup) {
                    EmptyView()
                }
                .hidden()
            }
            .foregroundColor(Color.theme.primaryText)
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct NoteCell_Previews: PreviewProvider {
    static var previews: some View {
        NoteCell(config: .note(dev.note))
    }
}
