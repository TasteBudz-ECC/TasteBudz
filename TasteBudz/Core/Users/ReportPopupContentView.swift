//
//  ReportPopupContentView.swift
//  TasteBudz
//
//  Created by student on 12/9/23.
//

import SwiftUI

struct ReportPopupContentView: View {
    @State private var isReportPopupPresented = false
       var body: some View {
           VStack {
               // Your other content here
               Button("Report") {
                   self.isReportPopupPresented.toggle()
                      
               }
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
