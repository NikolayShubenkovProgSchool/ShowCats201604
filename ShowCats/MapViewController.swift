//
//  MapViewController.swift
//  ShowCats
//
//  Created by Nikolay Shubenkov on 23/04/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage
import ChameleonFramework

class MapViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    var apiManger = FlickrAPIManager()
    var photos:[Photo] = []
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Найди кота"
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let vc = segue.destinationViewController as? PhotoDetailedViewController,
            let photo = sender as? Photo else {
                return
        }
        vc.photo = photo
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
        imageView.contentMode = .ScaleAspectFill
        
        //зададим левую часть детального пузыря
        photoView?.leftCalloutAccessoryView = imageView
        //справа будет кнопка
        photoView?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)

        //можно ли показывать пузырек с подробной информацией
        photoView?.canShowCallout = true
        
        photoView?.annotation = photoToShow
        
        return photoView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        guard let photo = view.annotation as? Photo else {
            return
        }
        
        let imageView = view.leftCalloutAccessoryView as! UIImageView
        
        imageView.sd_setImageWithURL(NSURL(string: photo.smallImageLink)!,
                                     placeholderImage: nil,
                                     options: [.ProgressiveDownload])
    }
    
    //переход на новый экран при касании детального view на карте
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let photo = view.annotation as? Photo else {
            return
        }
        performSegueWithIdentifier("ShowPhoto", sender: photo)
    }
    
}








