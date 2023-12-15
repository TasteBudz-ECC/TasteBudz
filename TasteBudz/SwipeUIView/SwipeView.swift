//
//  SwipeView.swift
//  TasteBudz
//
//  Created by Litao Li on 11/3/23.
//

import SwiftUI


//struct Restaurant {
//    var name: String
//    var type: String
//    //    var price: String
//    var images: [String: (imageURL: String, name: String)] = [
//        "key1": (imageURL: "https://media-cdn.tripadvisor.com/media/photo-s/08/90/b5/19/bar-louie.jpg", name: "Image 1"),
//        "key2": (imageURL: "https://cdn.vox-cdn.com/thumbor/SAj88pWQK1Q0XsOtgliyoux1YFY=/0x0:3745x2507/1200x800/filters:focal(1574x955:2172x1553)/cdn.vox-cdn.com/uploads/chorus_image/image/66206647/167139659.jpg.0.jpg", name: "Image 2"),
//        "key3": (imageURL: "https://hhrevolution.com/wp-content/uploads/2022/02/Bar-Louie-Happy-Hour-4.jpg", name: "Image 3"),]
//
//    var address: String
//    var rating: Int
//    var hours: String
//
//    // Feature Edits
//    // var description: String
//    // var review: String
//    // var website: String
//
//}

struct SwipeView: View {
    var restID: String
    //    @State var restaurant: Restaurant?
    @State var name: String = ""
    @State var type: String = ""
    @State var address: String = ""
    @State var rating: Int = -1
    @State var hours: String = ""
    @State var images: [String] = []
    let defaultImages: [String] = [
        "https://media-cdn.tripadvisor.com/media/photo-s/08/90/b5/19/bar-louie.jpg",
        "https://cdn.vox-cdn.com/thumbor/SAj88pWQK1Q0XsOtgliyoux1YFY=/0x0:3745x2507/1200x800/filters:focal(1574x955:2172x1553)/cdn.vox-cdn.com/uploads/chorus_image/image/66206647/167139659.jpg.0.jpg",
        "https://hhrevolution.com/wp-content/uploads/2022/02/Bar-Louie-Happy-Hour-4.jpg"
    ]
    
    var body: some View {
        
        ScrollView(){
            
            //            ZStack {
            //                GeometryReader { geometry in
            //                    Rectangle()
            //                        .frame(width: geometry.size.width, height: geometry.size.height)
            //                        .foregroundColor(Color.white) // Set the background color
            //                }
            VStack {
                VStack(alignment: .leading) {
                    HStack{
                        if name == "N/A" {
                            Text("Bar Louie").font(.title)
                                .padding(.horizontal)
                        } else {
                            Text(name).font(.title)
                                .padding(.horizontal)
                        }
                        
                        if rating == -1 {
                            StarRatingView(rating: 5, spacing: 1.0)
                        } else {
                            StarRatingView(rating: rating, spacing: 1.0)
                        }
                    }
                    
                    if type == "N/A" {
                        Text("Bar and Grill").foregroundColor(Color.gray)
                            .padding(.horizontal)
                            .padding(.bottom)
                    } else {
                        Text(type).foregroundColor(Color.gray)
                            .padding(.horizontal)
                        
                    }
                    
                    ZStack {
                        Rectangle() // grab image from yelp
                            .frame(width: 350, height: 400)
                            .foregroundColor(Color.blue)
                            .cornerRadius(20)
                        
                        Text("Image")
                            .foregroundColor(Color.white)
                        
                        TabView {
                            ForEach(images.isEmpty ? defaultImages : images, id: \.self) { imageUrl in
                                AsyncImage(url: URL(string: imageUrl)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 350, height: 400)
                                        .cornerRadius(20)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                        .onAppear {
                            if images.isEmpty {
                                print(defaultImages[0])
                                print(defaultImages[1])
                                print(defaultImages[2])
                            } else {
                                print(images[0])
                                print(images[1])
                                print(images[2])
                            }
                        }
                    }
                    Text("Overview")
                        .foregroundColor(Color.gray)
                        .padding()
                    
                }
                
                
                
                
                //                    Text("Experience your local bar with handcrafted martinis, cocktails and a scratch kitchen during happy hour and late night!")
                //                        .frame(width: 300)
                //                        .padding()
                
                VStack(alignment: .leading) { // IDK why this is not leading
                    HStack {
                        Image(systemName: "pin")
                        if address == "N/A" {
                            Text("1325 S Halsted St, Chicago, IL 60607")
                        } else {
                            Text(address)
                        }
                        
                    }.padding(.bottom, 10)
                    
                    HStack { // Need to make image at the top; need to be same line as Monday
                        Image(systemName: "clock").padding(.bottom, 10)
                        VStack (alignment: .leading){ // Create function to get info from Yelp
                            if hours == "N/A" {
                                Text("Monday 11am-12am")
                                Text("Tuesday 11am-12am")
                                Text("Wednesday 11am-12am")
                                Text("Thursday 11am-12am")
                                Text("Friday 11am-12am")
                                Text("Saturday 11am-12am")
                                Text("Sunday 11am-12am")
                            } else {
                                Text(hours)
                            }
                            
                        }
                    }
                }
                
            }
            //        }
            //                }.onAppear {
            //                    Task {
            //                        restDetailRetrievalAll(businessID: restID) { businessDetails in
            //                            if let businessDetails = businessDetails {
            //                                // Get name
            //                                name = businessDetails.name ?? "N/A"
            //                                print("Business name: \(businessDetails.name ?? "N/A")")
            //
            //                                // Get type
            //                                type = businessDetails.categories?.first?.title ?? "N/A"
            //                                print("Business type: \(businessDetails.categories?.first?.title ?? "N/A")")
            //
            //                                // Get images
            //                                images = businessDetails.photos ?? []
            //                                print("Business photos: \(businessDetails.photos ?? [])")
            //                                if let imageURL = businessDetails.imageURL {
            //                                    images.append(imageURL)
            //                                } else {
            //                                    // Handle the case where imageURL is nil
            //                                    // You might want to provide a default image or take appropriate action
            //                                    print("Image URL is nil for \(businessDetails.name ?? "Unknown Business")")
            //                                }
            //                                print("Images: \(images)")
            //
            //                                // Get address
            //                                address = buildAddress(location: businessDetails.location)
            //                                print("Business address: \(buildAddress(location: businessDetails.location))")
            //
            //                                // Get Rating
            //                                rating = businessDetails.rating ?? -1
            //                                print("Business photos: \(businessDetails.rating ?? -1)")
            //
            //
            //                                // Get Hours
            //                                hours = buildHours(hours: businessDetails.hours)
            //                                print("Business address: \(buildHours(hours: businessDetails.hours))")
            //
            //                            } else {
            //                                print("Failed to retrieve business details.")
            //                            }
            //                        }
            //
            //
            //                    }
            //                }
        }
        }
    }
    
    
    struct SwipeView_Previews: PreviewProvider {
        static var previews: some View {
            SwipeView(restID: "tR5DolsS4iOwfx070lENSw")
        }
    }
    
    
    func restDetailRetrievalAll(businessID: String, completion: @escaping (BusinessDetails?) -> Void) {
        print("businessID: \(businessID)")
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
                    let decoder = JSONDecoder()
                    let businessDetails = try decoder.decode(BusinessDetails.self, from: data)
                    print(businessDetails)
                    completion(businessDetails)
                } catch {
                    print("Error decoding JSON: \(error)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    
    
    
    // MARK: - Business
    struct BusinessDetails: Codable {
        let id, alias, name: String?
        let imageURL: String?
        let isClaimed, isClosed: Bool?
        let url: String?
        let phone, displayPhone: String?
        let reviewCount: Int?
        let categories: [CategoryID]?
        let rating: Int?
        let location: LocationID?
        let coordinates: CoordinatesID?
        let photos: [String]?
        let price: String?
        let hours: [Hour]?
        let transactions: [String]?
        
        //    init() {
        //            self.id = ""
        //            self.alias = ""
        //            self.name = ""
        //            self.imageURL = ""
        //            self.isClaimed = false
        //            self.isClosed = false
        //            self.url = ""
        //            self.phone = ""
        //            self.displayPhone = ""
        //            self.reviewCount = 0
        //            self.categories = []
        //            self.rating = 0
        //            self.location = LocationID(address1: "", address2: "", address3: "", city: "", zipCode: "", country: "", state: "", displayAddress: [], crossStreets: "")
        //            self.coordinates = CoordinatesID(latitude: 0.0, longitude: 0.0)
        //            self.photos = []
        //            self.price = ""
        //            self.hours = []
        //            self.transactions = []
        //        }
        
        enum CodingKeys: String, CodingKey {
            case id, alias, name
            case imageURL = "image_url"
            case isClaimed = "is_claimed"
            case isClosed = "is_closed"
            case url, phone
            case displayPhone = "display_phone"
            case reviewCount = "review_count"
            case categories, rating, location, coordinates, photos, price, hours, transactions
        }
    }
    
    // MARK: - Category
    struct CategoryID: Codable {
        let alias, title: String?
    }
    
    // MARK: - Coordinates
    struct CoordinatesID: Codable {
        let latitude, longitude: Double?
        
        //    init(latitude: Double? = nil, longitude: Double? = nil) {
        //            self.latitude = latitude
        //            self.longitude = longitude
        //        }
    }
    
    // MARK: - Hour
    struct Hour: Codable {
        let hourOpen: [Open]?
        let hoursType: String?
        let isOpenNow: Bool?
        
        enum CodingKeys: String, CodingKey {
            case hourOpen = "open"
            case hoursType = "hours_type"
            case isOpenNow = "is_open_now"
        }
    }
    
    // MARK: - Open
    struct Open: Codable {
        let isOvernight: Bool?
        let start, end: String?
        let day: Int?
        
        enum CodingKeys: String, CodingKey {
            case isOvernight = "is_overnight"
            
            case start, end, day
        }
    }
    
    // MARK: - Location
    struct LocationID: Codable {
        let address1, address2, address3, city: String?
        let zipCode, country, state: String?
        let displayAddress: [String]?
        let crossStreets: String?
        
        //    init(
        //            address1: String? = nil,
        //            address2: String? = nil,
        //            address3: String? = nil,
        //            city: String? = nil,
        //            zipCode: String? = nil,
        //            country: String? = nil,
        //            state: String? = nil,
        //            displayAddress: [String]? = nil,
        //            crossStreets: String? = nil
        //        ) {
        //            self.address1 = address1
        //            self.address2 = address2
        //            self.address3 = address3
        //            self.city = city
        //            self.zipCode = zipCode
        //            self.country = country
        //            self.state = state
        //            self.displayAddress = displayAddress
        //            self.crossStreets = crossStreets
        //        }
        
        enum CodingKeys: String, CodingKey {
            case address1, address2, address3, city
            case zipCode = "zip_code"
            case country, state
            case displayAddress = "display_address"
            case crossStreets = "cross_streets"
        }
    }
