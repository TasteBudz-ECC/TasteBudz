//
//  ProfileViewModel.swift
//  TasteBudz
//
//  Created by student on 12/1/23.
//

import Foundation
import Combine

class CurrentUserProfileViewModel: ObservableObject {
    @Published var currentUser: User?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
     setUpSubscribers()
    }
    private func setUpSubscribers() {
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in: &cancellables)
    }
}
