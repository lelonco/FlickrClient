//
//  SearchViewController.swift
//  FlickrClient
//
//  Created by Yaroslav on 5/13/19.
//  Copyright © 2019 Yaroslav. All rights reserved.
//

import UIKit
import FlickrKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var findBtn: UIButton!
    
    var imageInfos: [ImageInfo] = []
    let reuseIdentifier = "searchCell"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        FlickrKit.shared().initialize(withAPIKey: apiKey, sharedSecret: secret)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! SearchCollectionViewCell
        
        if let url = imageInfos[indexPath.row].urlImage {
            cell.photoImage.imageFromServerURL(urlString: String("\(url)"))
        }
        
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail"{
            let cell = sender as! SearchCollectionViewCell
            if let indexPath = self.collectionView.indexPath(for: cell) {
                let detailVC = segue.destination as! ViewController
                detailVC.image = cell.photoImage.image
                detailVC.titleText = imageInfos[indexPath.row].title
            }
        }
    }
    
    @IBAction func find(_ sender: Any) {
        
        let text = searchText.text
        imageInfos = []	
        let flickrSearch = FKFlickrPhotosSearch()
        flickrSearch.text = text
        FlickrKit.shared().call(flickrSearch) { (response, error) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                if let response = response, let dataArray = FlickrKit.shared().photoArray(fromResponse: response) {
                    // Pull out the photo urls from the results
                    for item in dataArray {
                        
//                        print(item)
                        let photoURL = FlickrKit.shared().photoURL(for: FKPhotoSize.largeSquare150, fromPhotoDictionary: item)
                        self.imageInfos.append(ImageInfo(urlImage: photoURL, owner: item["owner"] as? String, title: item["title"] as? String))
                        
//                        print(photoURL)
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
