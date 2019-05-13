//
//  ViewController.swift
//  FlickrClient
//
//  Created by Yaroslav on 5/13/19.
//  Copyright © 2019 Yaroslav. All rights reserved.
//

import UIKit
import FlickrKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    var titleText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        titleLabel.text = titleText
        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
