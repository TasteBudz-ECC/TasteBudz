//
//  RecommendViewModel.swift
//  TasteBudz
//
//  Created by Litao Li on 11/30/23.
//

import Foundation
import Combine

final class RecommendViewModel: ObservableObject {
    @Published var businesses = [Business]()
    @Published var searchText = ""
    @Published var selectedRestaurants: Array<Business> = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    
    init() {
        $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchTerm in
                self?.search(searchTerm: searchTerm)
            }
            .store(in: &cancellables)
    }
    
    func search(searchTerm: String) {
        YelpApiService.live.search(searchTerm, "Chicago")
            .sink { [weak self] businesses in
                self?.businesses = businesses
            }
            .store(in: &cancellables)
        
        print("Search Text: \(searchTerm)")
    }
}
