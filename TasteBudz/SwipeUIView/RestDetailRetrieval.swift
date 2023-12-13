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

//func restDetailRetrieval(businessID: String, toRetrieve: String /*completion: @escaping (String?*/) -> String {
//
//    let endpoint = URL(string: "https://api.yelp.com/v3/businesses/\(businessID)")!
//
//    var request = URLRequest(url: endpoint)
//    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//    
//    var result = ""
//
//    URLSession.shared.dataTask(with: request) { (data, response, error) in
//        if let error = error {
//            print("Error: \(error)")
//            return
//        }
//
//        if let data = data {
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                let businessData = json as? [String: Any]
//                result = (businessData?[toRetrieve] as? String)!
//                    print("Business \(toRetrieve): \(result)")
//               
//                
//            } catch {
//                print("Error decoding JSON: \(error)")
//                return
//            }
//        } else {
//            return
//        }
//    }.resume()
//    
//    return result
//}

//func restDetailRetrieval(businessID: String, toRetrieve: String) async throws -> String? {
//    let endpoint = URL(string: "https://api.yelp.com/v3/businesses/\(businessID)")!
//
//    var request = URLRequest(url: endpoint)
//    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//
//    do {
//        let (data, _) = try await URLSession.shared.data(from: endpoint) // Pass URL directly
//        let json = try JSONSerialization.jsonObject(with: data, options: [])
//
//        if let businessData = json as? [String: Any],
//           let result = businessData[toRetrieve] as? String {
//            print("Business \(toRetrieve): \(result)")
//            return result
//        } else {
//            print("returned nil")
//            return nil
//        }
//    } catch {
//        print("Error: \(error)")
//        throw error
//    }
//}
