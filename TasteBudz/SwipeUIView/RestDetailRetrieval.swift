//
//  RestDetailRetrieval.swift
//  TasteBudz
//
//  Created by Litao Li on 12/12/23.
//

import Foundation

func restDetailRetrieval(businessID: String, toRetrieve: String, completion: @escaping (String?) -> Void) {

    let endpoint = URL(string: "https://api.yelp.com/v3/businesses/\(businessID)")!

    var request = URLRequest(url: endpoint)
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Error: \(error)")
            completion(nil)
            return
        }

        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let businessData = json as? [String: Any],
                   let result = businessData[toRetrieve] as? String {
                    print("Business \(toRetrieve): \(result)")
                    completion(result)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        } else {
            completion(nil)
        }
    }.resume()
}
