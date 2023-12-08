//
//  ReportButtonView.swift
//  TasteBudz
//
//  Created by Arely Herrera on 12/7/23.
//

import SwiftUI

struct ReportButtonView: View {
    var onButtonTap: () -> Void
    
    var body: some View {
        Button(action: {
            onButtonTap()
        }) {
            Text("Report User")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}
























//struct ReportButtonView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    ReportButtonView()
//}
