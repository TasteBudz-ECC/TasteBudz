//
//  DisplayListofRestaurants.swift
//  TasteBudz
//
//  Created by Litao Li on 12/5/23.
//

import SwiftUI

struct DisplayListofRestaurants: View {
    @ObservedObject var viewModel = RecommendViewModel()
    
    var body: some View {
        List(viewModel.businesses, id: \.id) { business in
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                            Text(business.name ?? "no name")
                                .font(.headline)
                            Text(business.location?.displayAddress?.joined(separator: ", ") ?? "No address")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                }
                Spacer()
                // Add a clickable icon (for example, Image(systemName: "plus.circle"))
                Image(systemName: viewModel.selectedRestaurants.contains(business) ? "checkmark.circle.fill" : "plus.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(viewModel.selectedRestaurants.contains(business) ? .green : .blue)
                                        .onTapGesture {
                                            toggleSelection(for: business)
                                        }
                                }
                                .padding(.vertical, 8)
                            }}


private func toggleSelection(for business: Business) {
        if viewModel.selectedRestaurants.contains(business) {
            viewModel.selectedRestaurants.removeAll { b in
                return b == business
            }
        } else {
            viewModel.selectedRestaurants.append(business)
        }
    }
}



//#Preview {
//    DisplayListofRestaurants()
//}


struct DisplayListofRestaurants_Previews: PreviewProvider {
    static var previews: some View {
        DisplayListofRestaurants()
    }
}
