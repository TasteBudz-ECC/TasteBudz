//
//  SignUpModel.swift
//  TasteBudz
//
//  Created by Litao Li on 12/17/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


class SignUpModel: ObservableObject {
    @Published var userNetwork: [String] = []
    @Published var networkRestaurantKeys: Set<String> = []
    @Published var restInfoDict: [String: (name: String, type: String, photos: [String], address: String, rating: Double, hours: String, imageURL: String)] = [:]
    @Published var restDictEmpty: Bool = true
    
}
