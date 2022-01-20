//
//  CustomImageView.swift
//  Auctioneer
//
//  Created by Lester Cheong on 20/1/22.
//

import Foundation
import UIKit

class CustomImageView : UIImageView {
    
    func loadImage(from url: URL){
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard
                    let data = data,
                    let newImage = UIImage(data: data)
                else{
                    print("Couldn't Load Image From URL: \(url)")
                    return
                }
                DispatchQueue.main.async {
                    self.image = newImage
                }
        }
        task.resume()
    }
    
}
