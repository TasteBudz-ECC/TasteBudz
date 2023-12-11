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
            Text("Click below to make a report:")
            // Your other content here
            Button("Report") {
                self.isReportPopupPresented.toggle()
                   
            }
            .foregroundColor(.black)
            .padding()
            
            // Your other content here
        }
        .sheet(isPresented: $isReportPopupPresented) {
            ReportPopupView(isPresented: self.$isReportPopupPresented)
        }
    }
}

struct ReportPopupContentView_Previews: PreviewProvider {
    static var previews: some View {
        ReportPopupContentView()
    }
}
