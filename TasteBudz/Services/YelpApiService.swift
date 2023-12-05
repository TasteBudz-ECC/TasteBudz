//
//  YelpApiService.swift
//  TasteBudz
//
//  Created by Litao Li on 11/30/23.
//

import Foundation
import CoreLocation
import Combine

let apiKey = "CBz-Ykj4Kpaw9hum4DDI9hIJcRg7Q0uvtbEeAe_znKmG-HF6av3NUdQBI1OZihgG0YILrSS6KOb1ZRsoCs_HSNc4KutlGnkOKAAYw7p_MRXvdgdn4EBtwMBsxc1VZXYx"

struct YelpApiService {
    // search term        location         /// output to update list
    var search: (String, String) -> AnyPublisher<[Business], Never>
}

extension YelpApiService {
    static let live = YelpApiService { term, location in
        // url component for yelp endpoint
        print("term: \(term)")
        var urlComponents = URLComponents(string: "https://api.yelp.com")!
        urlComponents.path = "/v3/businesses/search"
        urlComponents.queryItems = [
            .init(name: "term", value: term),
            .init(name: "location", value: "Chicago")
        ]
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        // URL request and return models: [Busineses]
        print("Restaurant Name: \(request)")
        
        let ret = URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: SearchResult.self, decoder: JSONDecoder())
            .map(\.businesses)
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
        print("ret: \(ret)")
        return ret
    }
    
}


// MARK: - SearchResult
struct SearchResult: Codable {
    let businesses: [Business]
}

// MARK: - Business
struct Business: Codable, Hashable {
    let id, alias, name: String?
    let imageURL: String?
    let isClosed: Bool?
    let url: String?
    let reviewCount: Double?
    let categories: [Category]?
    let rating: Double?
    let coordinates: Coordinates?
    let transactions: [String]?
    let price: String?
    let location: Location?
    let phone, displayPhone: String?
    let distance: Double?
    
    // Implement Hashable protocol
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        static func == (lhs: Business, rhs: Business) -> Bool {
            return lhs.id == rhs.id
        }

    enum CodingKeys: String, CodingKey {
        case id, alias, name
        case imageURL = "image_url"
        case isClosed = "is_closed"
        case url
        case reviewCount = "review_count"
        case categories, rating, coordinates, transactions, price, location, phone
        case displayPhone = "display_phone"
        case distance
    }
}

// MARK: - Category
struct Category: Codable {
    let alias, title: String?
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude, longitude: Double?
}

// MARK: - Location
struct Location: Codable {
    let address1, address2, address3, city: String?
    let zipCode, country, state: String?
    let displayAddress: [String]?

    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city
        case zipCode = "zip_code"
        case country, state
        case displayAddress = "display_address"
    }
}

        
        
        

