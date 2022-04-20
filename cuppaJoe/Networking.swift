//
//  Networking.swift
//  cuppaJoe
//
//  Created by Matt Goodhart on 4/19/22.
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
    
//walk through this. simpler way to handle?  change do-let-tr-catch  into guard conditions? remove responsetype attribute since I'll only ever use one response?
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
