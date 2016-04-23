//
//  FlickrAPIManager.swift
//  ShowCats
//
//  Created by Nikolay Shubenkov on 23/04/16.
//  Copyright © 2016 Nikolay Shubenkov. All rights reserved.
//

import UIKit

import Alamofire

//https://api.flickr.com/services/rest/?
//method=flickr.photos.search&
//api_key=2a30e293c0809c659d40e281d1676862&
//format=json&
//nojsoncallback=1&
//api_sig=6b8cf388eab02ac99c0c9fd0feb03428

//tags=cat&

class FlickrAPIManager: NSObject {
    struct Constancts {
        static let url = "https://api.flickr.com/services/rest/"
        
    }
  
    // последний параметр - это функция, принимающая опциональный массив из фото и опциональную строку с ошибкой
    func find(searchWord:String,completion:(data:[Photo]?,error:String?)->Void){
        
        let methodName = "flickr.photos.search"
        
        var params = [String:AnyObject]()
        
        params["method"] = methodName
        
        params["api_key"] = "2b2c9f8abc28afe8d7749aee246d951c"
        params["format"]  = "json"
        params["nojsoncallback"] = 1
        
        params["tags"] = searchWord
        params["extras"] = [//запросить доп. информацию по фотографиям
            "url_l",        //ссылка на картинку большого размера
            "geo",          //это координаты
            "owner_name",   //автор фотографии
            "url_s",        //ссылка для иконки
            "description"   //описание, которое предоставил автор
        ].joinWithSeparator(",")//схлопнем массив строк в одну строку, разделив строки запятой
        
        
        Alamofire.request(.GET, //Метод запроса
                          Constancts.url,//путь к API
                          parameters: params,//параметры запроса
                          encoding: .URL,//как параметры передать. URL - означает, что они будут добавлены к ссылке
                          headers: nil)//дополнительные заголовки запроса
        .responseJSON { (response) in
            if response.result.error != nil {
                print("error to find photo")
                completion(data: nil,
                          error: response.result.error!.description)
                return
            }
            
            guard let dataToParse = response.result.value as? [String: AnyObject] else {
                print("error to get data to parse")
                completion(data: nil,
                    error: response.result.error!.description)
                return
            }
            let parsedObjects = self.parsePhotos(dataToParse)
            print(parsedObjects)
            completion(data: parsedObjects, error: nil)
        }
    }
    
    func parsePhotos( photosInfoes:[String : AnyObject] ) -> [Photo]{
        
        guard let photos = photosInfoes["photos"] as? [String : AnyObject],//достанем словарь по ключу photos
              let photoArray = photos["photo"] as? [ [String : AnyObject] ]// достанем массив словарей по ключу photo
            else {
            return [Photo]()
        }
        var readyObjects = [Photo]()
        //переберем массив из словариков
        for photoInfo in photoArray {
            if let parsedPhoto = Photo(info: photoInfo){
                readyObjects.append(parsedPhoto)
            }
        }
        
        return readyObjects
    }
}



















