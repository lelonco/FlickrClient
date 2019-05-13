//
//  TabBarControler.swift
//  FlickrClient
//
//  Created by Yaroslav on 5/13/19.
//  Copyright © 2019 Yaroslav. All rights reserved.
//

import UIKit
import FlickrKit
import MapKit
import CoreLocation


var longitude: String = "55.751244"
var latitude: String = "37.618423"

let apiKey = "05c17264d481fe29cd3223cfe89d0afe"
let secret = "8dbda8fe9043d1c7"

class TabBarControler: UITabBarController, CLLocationManagerDelegate {
    
      let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latitude = String(locValue.latitude)
        longitude = String(locValue.longitude)
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
