//
//  CustomImageView.swift
//  Auctioneer
//
//  Created by Lester Cheong on 20/1/22.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView : UIImageView {
    var task:URLSessionDataTask!
    let spinner = UIActivityIndicatorView(style: .gray)
    
    func loadImage(from url: URL){
        image = nil
        spinner.startAnimating()

        
        if let task = task {
            task.cancel()
        }
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = imageFromCache
        }
        
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard
                    let data = data,
                    let newImage = UIImage(data: data)
                else{
                    print("Couldn't Load Image From URL: \(url)")
                    return
                }
                
                imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
                
                DispatchQueue.main.async {
                    self.image = newImage
                }
        }
        task.resume()
    }
    
    func addSpinner() {
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.startAnimating()
    }
    
}
