//
//  MapViewController.swift
//  ShowCats
//
//  Created by Nikolay Shubenkov on 23/04/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    var apiManger = FlickrAPIManager()
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
    }
    
    @IBAction func showUserLocation(sender: AnyObject) {
        
        let coordinate = mapView.userLocation.coordinate
        
        mapView.setCenterCoordinate(coordinate, animated: true)
        
    }
    
    @IBAction func searhButtonPressed(sender: AnyObject) {
        apiManger.find("Cat")
    }
    

    
}
