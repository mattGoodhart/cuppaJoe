//
//  Networking.swift
//  cuppaJoe
//
//  Created by Alicia Goodhart on 4/19/22.
//

import Foundation

struct RandomCoffeeResponse: Codable {
    let imageString: String
    
    enum CodingKeys: String, CodingKey {
        case imageString = "file"
    }
}


class Networking {
    static let shared = Networking()
    private init() {}
    
    var imageURL : URL?
    var imageData: Data?
    
    
    
    
//    func getImageURLForRandomCoffee(endpointString: String) {
//        //activityIndicator.startAnimating()
//        if let url = URL(string: endpointString) {
//
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                guard let data = data else {
//                    print("Download failed: \(String(describing: error))")
//                    return
//                }
//                do {
//                    let response = try JSONDecoder().decode(RandomCoffeeResponse.self, from: data)
//                    print(response)
//                    if let url = URL(string: response.imageString) {
//                        DispatchQueue.main.async {
//                            self.imageURL = url
//                        }
//                    }
//                } catch {
//                    print("JSON Parsing failed: \(error)")
//                }
//            }
//            .resume()
//        }
//    }
    
    func getImageURLForRandomCoffee<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error  in
            guard error == nil, let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                    print(error!)
                }
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func fetchText(at url: URL, with completion: @escaping ((String) -> Void)) {
        DispatchQueue.global().async {
            guard let textData = try? String(contentsOf: url) else {
                print("Text download failed for URL: \(url)")
                return
            }
            DispatchQueue.main.async {
                completion(textData)
            }
        }
    }
    
    
    
    
    func fetchData(at url: URL, with completion: @escaping ((Data?) -> Void)) {
        DispatchQueue.global().async { //necessary?
            print("starting image download")
            guard let data = try? Data(contentsOf: url) else {
                DispatchQueue.main.async {
                    print("Download failed for URL: \(url)")
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
    
    
}
