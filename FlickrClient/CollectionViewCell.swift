//
//  CollectionViewCell.swift
//  FlickrClient
//
//  Created by Yaroslav on 5/13/19.
//  Copyright © 2019 Yaroslav. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var photoImage: UIImageView!
}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        self.image = nil
        let urlStringNew = urlString.replacingOccurrences(of: " ", with: "%20")
        URLSession.shared.dataTask(with: NSURL(string: urlStringNew)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }
    
}

