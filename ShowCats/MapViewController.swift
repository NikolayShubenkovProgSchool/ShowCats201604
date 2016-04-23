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
    var photos:[Photo] = []
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    @IBAction func showUserLocation(sender: AnyObject) {
        
        let coordinate = mapView.userLocation.coordinate
        
        mapView.setCenterCoordinate(coordinate, animated: true)
        
    }
    
    @IBAction func searhButtonPressed(sender: AnyObject) {
        apiManger.find("Cat") { (data, error) in
            if error != nil {
                print(error)
                return
            }
            guard let dataExists = data else {
                return
            }
            self.photos = dataExists
            self.updateMapViewWithPhotos(self.photos)
        }
    }
    
    func updateMapViewWithPhotos(photos:[Photo]){
        mapView.addAnnotations(photos)
    }
}

extension MapViewController : MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        //если нам передали метку пользователя, которая не относится к типу Photo
        //вернем nil. Тогда MapView сам что-нибудь придумает
        guard let photoToShow = annotation as? Photo else {
            return nil
        }
        
        //уникальный идентификатор для метки с фотографией
        let id = "PhotoID"
        var photoView = mapView.dequeueReusableAnnotationViewWithIdentifier(id)
        
        if photoView == nil {
            photoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
        }
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        //зададим левую часть детального пузыря
        photoView?.leftCalloutAccessoryView = imageView
        
        photoView?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)

        //можно ли показывать пузырек с подробной информацией
        photoView?.canShowCallout = true
        
        photoView?.annotation = annotation
        
        return photoView
    }
    
}





