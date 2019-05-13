//
//  NearPhotosControler.swift
//  FlickrClient
//
//  Created by Yaroslav on 5/13/19.
//  Copyright © 2019 Yaroslav. All rights reserved.
//

import UIKit
import FlickrKit
import CoreLocation

private let reuseIdentifier = "nearPhCell"

class NearPhotosControler: UICollectionViewController, CLLocationManagerDelegate {
    
    var phUrls:[URL] = []
    var imageInfos:[ImageInfo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FlickrKit.shared().initialize(withAPIKey: apiKey, sharedSecret: secret)

        let flickrNear = FKFlickrPhotosSearch()
//        flickrNear.text = "Mykolaiv"
        flickrNear.per_page = "15"
        flickrNear.lon = longitude
        flickrNear.lat = latitude
        print("Loc = \(longitude) \(latitude)")
        FlickrKit.shared().call(flickrNear) { (response, error) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                if let response = response, let dataArray = FlickrKit.shared().photoArray(fromResponse: response) {
                    // Pull out the photo urls from the results
                    for item in dataArray {
                        
                        print(item)
                        let photoURL = FlickrKit.shared().photoURL(for: FKPhotoSize.largeSquare150, fromPhotoDictionary: item)
                        self.phUrls.append(photoURL)
                        self.imageInfos.append(ImageInfo(urlImage: photoURL, owner: item["owner"] as? String, title: item["title"] as? String))
                        
                        print(photoURL)
                    }
                } else {
                    // Iterating over specific errors for each service
                    if let error = error as NSError? {
                        switch error.code {
                        case FKFlickrInterestingnessGetListError.serviceCurrentlyUnavailable.rawValue:
                            break;
                        default:
                            break;
                        }
                        
                        let alert = UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
                        alert.show()
                    }
                }
                self.collectionView.reloadData()
                
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return phUrls.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell

        let url = phUrls[indexPath.row]
        cell.photoImage.imageFromServerURL(urlString: String("\(url)"))
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailSeg"{
            let cell = sender as! CollectionViewCell
            if let indexPath = self.collectionView.indexPath(for: cell) {
                var detailVC = segue.destination as! ViewController
                detailVC.image = cell.photoImage.image
                detailVC.titleText = imageInfos[indexPath.row].title
            }
            
        }
    }
 

}
