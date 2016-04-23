//
//  Photo.swift
//  ShowCats
//
//  Created by Nikolay Shubenkov on 23/04/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit
import MapKit

//    description =                 {
//        "_content" = "Another picture, I've made at Tierpark Goldau.";
//    };
//    id = 26316702730;
//    latitude = "47.051925";
//    longitude = "8.556416";
//    owner = "57256462@N07";
//    ownername = "Cloudtail the Snow Leopard";
//    title = "Wildcat in a tree";
//    "url_l" = "https://farm2.staticflickr.com/1595/26316702730_31645430d0_b.jpg";
//    "url_s" = "https://farm2.staticflickr.com/1595/26316702730_31645430d0_m.jpg";
//    "width_l" = 683;
//    "width_s" = 160;


class Photo: NSObject {
    var photoDescription = ""
//    let photoID:Int
    let long:Double
    let lat:Double
    let ownerName:String
    let title:String?
    let smallImageLink:String
    let largeImageLink:String
    
    //Знак вопроса означает, что инициализация объекта может завершиться не удачно и вместо объекта будет 
    //возвращено значение nil
    init?(info:[String:AnyObject]){
        guard let longitude = info["longitude"] as? String,
              let latitude  = info["latitude"]  as? String,
              let iconURL   = info["url_s"]     as? String,
              let largeURL  = info["url_l"]     as? String else {
              print("failed to create photo from object: \(info)")
                //отменим инициализацию объекта, вернув nil
              return nil
        }
        
        if let descriptionDictionary = info["description"] as? [String : AnyObject] {
            self.photoDescription = descriptionDictionary["_content"] as? String ?? ""
        }
        self.long = Double(longitude)!
        self.lat  = Double(latitude)!
        //извлечь значение по ключу ownername. Там должна лежать строка. Если строки нет, то задать занчение No owner
        self.ownerName = info["ownername"] as? String ?? "No owner"
        self.title     = info["title"] as? String
        
        self.smallImageLink = iconURL
        self.largeImageLink = largeURL
    }
}

extension Photo: MKAnnotation {
    var coordinate:CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    var subtitle: String? {
        return photoDescription
    }
}







