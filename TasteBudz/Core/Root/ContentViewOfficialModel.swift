//
//  ContentViewOfficialModel.swift
//  TasteBudz
//
//  Created by student on 11/30/23.
//

import Foundation
import Combine
import Firebase

class ContentViewOfficialModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        AuthService.shared.$userSession.sink { [weak self] userSession in
        self?.userSession = userSession
        }.store(in: &cancellables)
    }
}
