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
        VStack {
            HStack(alignment: .top, spacing: 12) {
                NavigationLink(value: user) {
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
            .sheet(isPresented: $showNoteActionSheet) {
                if case .note(let note) = config {
                    NoteActionSheetView(note: note, selectedAction: $selectedNoteAction)
                }
            }
            Divider()
        }
        .onChange(of: selectedNoteAction, perform: { newValue in
            switch newValue {
            case .block:
                print("DEBUG: Block user here..")
            case .hide:
                print("DEBUG: Hide thread here..")
            case .mute:
                print("DEBUG: Mute notes here..")
            case .unfollow:
                print("DEBUG: Unfollow here..")
            case .report:
                print("DEBUG: Report here..")
                print("isReportPopupPresented: \(isReportPopupPresented)")
                isReportPopupPresented = true
//                self.isReportPopupPresented.toggle()
                print("isReportPopupPresented: \(isReportPopupPresented)")
            case .none:
                break
            }
        })
        .sheet(isPresented: $isReportPopupPresented) {
            ReportPopupView(isPresented: self.$isReportPopupPresented)
                .onDisappear() {
//                    print("isReportPopupPresented: \(isReportPopupPresented)")
                    self.isReportPopupPresented = false
//                    print("isReportPopupPresented: \(isReportPopupPresented)")
                }
        }
        
        .foregroundColor(Color.theme.primaryText)
//        Text("isReportPopupPresented: \(String(isReportPopupPresented))")
    }
}
struct NoteCell_Previews: PreviewProvider {
    static var previews: some View {
        NoteCell(config: .note(dev.note))
    }
}
