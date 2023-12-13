import SwiftUI

struct YelpApiDetailsTestView: View {
    @State private var businessID = ""
    @State private var toRetrieve = ""
    
    let BarLouie: String = "tR5DolsS4iOwfx070lENSw"
    
    var body: some View {
        VStack {
            TextField("Enter Business ID", text: $businessID)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Enter Info to Retrieve", text: $toRetrieve)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Search") {
//                restDetailRetrieval(businessID: businessID, toRetrieve: toRetrieve)
                restDetailRetrieval(businessID: businessID, toRetrieve: toRetrieve) { result in
                    let result = result
                }
            }
            .padding()
            
//            Text(result ?? "Make sure toRetrieve variable is spelled correctly and capitalized correctly")
        }
        .padding()
    }
}

//func restDetailRetrieval(businessID: String, toRetrieve: String, completion: @escaping (String?) -> Void) {
//
//    let endpoint = URL(string: "https://api.yelp.com/v3/businesses/\(businessID)")!
//
//    var request = URLRequest(url: endpoint)
//    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//
//    URLSession.shared.dataTask(with: request) { (data, response, error) in
//        if let error = error {
//            print("Error: \(error)")
//            completion(nil)
//            return
//        }
//
//        if let data = data {
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                if let businessData = json as? [String: Any],
//                   let result = businessData[toRetrieve] as? String {
//                    print("Business \(toRetrieve): \(result)")
//                    completion(result)
//                } else {
//                    completion(nil)
//                }
//            } catch {
//                print("Error decoding JSON: \(error)")
//                completion(nil)
//            }
//        } else {
//            completion(nil)
//        }
//    }.resume()
//}
    
//    func restDetailRetrieval(businessID: String, toRetrieve: String) {
//
//        let endpoint = URL(string: "https://api.yelp.com/v3/businesses/\(businessID)")!
//
//        var request = URLRequest(url: endpoint)
//        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                print("Error: \(error)")
//                return
//            }
//
////            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
////                print("Unexpected response status code")
////                return
////            }
//
//
//            if let data = data {
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    if let businessData = json as? [String: Any] {
////                        print(businessData)
//                        if let result = businessData["\(toRetrieve)"] as? String {
//                                print("Business \(toRetrieve): \(result)")
//                            }
//                    }
//                } catch {
//                    print("Error decoding JSON: \(error)")
//                }
//            }
//        }.resume()
//    }


//#Preview {
//    YelpApiDetailsTestView()
//}
struct YelpApiDetailsTestView_Previews: PreviewProvider {
    static var previews: some View {
        YelpApiDetailsTestView()
    }
}

// EXAMPLE OF OUTPUT JSON FILE
//{
//  "id": "tR5DolsS4iOwfx070lENSw",
//  "alias": "bar-louie-university-village-chicago-2",
//  "name": "Bar Louie -University Village",
//  "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/3tnXQsIHT7eackbPBkEf7A/o.jpg",
//  "is_claimed": true,
//  "is_closed": false,
//  "url": "https://www.yelp.com/biz/bar-louie-university-village-chicago-2?adjust_creative=OoWVkoRmxIpNhmvJLFeq4g&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_lookup&utm_source=OoWVkoRmxIpNhmvJLFeq4g",
//  "phone": "+13127331411",
//  "display_phone": "(312) 733-1411",
//  "review_count": 250,
//  "categories": [
//    {
//      "alias": "bars",
//      "title": "Bars"
//    },
//    {
//      "alias": "newamerican",
//      "title": "New American"
//    },
//    {
//      "alias": "gastropubs",
//      "title": "Gastropubs"
//    }
//  ],
//  "rating": 3,
//  "location": {
//    "address1": "1325 S Halsted St",
//    "address2": "",
//    "address3": "",
//    "city": "Chicago",
//    "zip_code": "60607",
//    "country": "US",
//    "state": "IL",
//    "display_address": [
//      "1325 S Halsted St",
//      "Chicago, IL 60607"
//    ],
//    "cross_streets": "Maxwell St & Liberty St"
//  },
//  "coordinates": {
//    "latitude": 41.86470689900355,
//    "longitude": -87.6467016
//  },
//  "photos": [
//    "https://s3-media1.fl.yelpcdn.com/bphoto/hny-TFXrDzdlE6d68-ekYw/o.jpg",
//    "https://s3-media2.fl.yelpcdn.com/bphoto/BOFEQ9fhNWq4M4wV_eQjvA/o.jpg",
//    "https://s3-media2.fl.yelpcdn.com/bphoto/dSiQGfXBA74himezm822mg/o.jpg"
//  ],
//  "price": "$$",
//  "hours": [
//    {
//      "open": [
//        {
//          "is_overnight": false,
//          "start": "1100",
//          "end": "0000",
//          "day": 0
//        },
//        {
//          "is_overnight": false,
//          "start": "1100",
//          "end": "0000",
//          "day": 1
//        },
//        {
//          "is_overnight": false,
//          "start": "1100",
//          "end": "0000",
//          "day": 2
//        },
//        {
//          "is_overnight": false,
//          "start": "1100",
//          "end": "0000",
//          "day": 3
//        },
//        {
//          "is_overnight": true,
//          "start": "1100",
//          "end": "0100",
//          "day": 4
//        },
//        {
//          "is_overnight": true,
//          "start": "1100",
//          "end": "0100",
//          "day": 5
//        },
//        {
//          "is_overnight": false,
//          "start": "1100",
//          "end": "0000",
//          "day": 6
//        }
//      ],
//      "hours_type": "REGULAR",
//      "is_open_now": true
//    }
//  ],
//  "transactions": [
//    "delivery",
//    "pickup"
//  ]
//}

