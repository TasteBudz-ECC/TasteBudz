//
//  ReportPopupContentView.swift
//  TasteBudz
//
//  Created by Arely Herrera on 12/7/23.
//
// MainContentView.swift
import SwiftUI
struct ReportPopupContentView: View {
    @State private var isReportPopupPresented = false
    var body: some View {
        VStack {
            
            Text("Report a Problem")
                .font(.title)
                .fontWeight(.bold)
            
            
            Text("If you encounter any issues or have concerns, please use this feature to report them to us. Your feedback is valuable in improving our app.")
                .foregroundColor(.gray)
                .padding()

            Text("Click below to make a report:")
            Button("Report") {
                self.isReportPopupPresented.toggle()
                
            }
            .foregroundColor(.blue)
            .padding()
        }
        .sheet(isPresented: $isReportPopupPresented) {
            ReportPopupView(isPresented: self.$isReportPopupPresented)
        }
        Spacer()
    }
}

struct ReportPopupContentView_Previews: PreviewProvider {
    static var previews: some View {
        ReportPopupContentView()
    }
}
