//
//  MainViewController.swift
//  cuppaJoe
//
//  Created by Matt Goodhart on 4/19/22.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newCoffeeButton: UIButton!
    
    let endpointString: String = "https://coffee.alexflipnote.dev/random.json"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        fetchRandomCoffee()
    }
    
    func fetchRandomCoffee() {
        
        self.activityIndicator.startAnimating()
        if let jsonURL = URL(string: endpointString){
            Networking.shared.getImageURLForRandomCoffee(url: jsonURL, responseType: RandomCoffeeResponse.self) { response, error in
                
                guard let response = response else {
                    print("Problem fetching JSON: \(String(describing: error))")
                    self.activityIndicator.stopAnimating()
                    return
                }
                if let url = URL(string:response.imageString){
                    Networking.shared.fetchData(at: url) { data in
                        guard let data = data, let coffeeImage = UIImage(data: data) else {
                            self.activityIndicator.stopAnimating() // send to main thread async?
                            print("Error Downloading Image!")
                            return
                        }
                        self.imageView.image = coffeeImage
                        self.activityIndicator.stopAnimating()
                    }
                } else {
                    print("Couldn't make URL")
                    self.activityIndicator.stopAnimating()
                }
            }
        } else {
            print("Couldnt make JSON URL")
        }
    }
    
    @IBAction func buttonHit(_sender: UIButton) {
        fetchRandomCoffee()
    }
}
