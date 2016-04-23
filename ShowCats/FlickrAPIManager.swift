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
  
    func find(searchWord:String){
        
        let methodName = "flickr.photos.search"
        
        var params = [String:AnyObject]()
        
        params["method"] = methodName
        
        params["api_key"] = "2b2c9f8abc28afe8d7749aee246d951c"
        params["format"]  = "json"
        params["nojsoncallback"] = 1
        
        params["tags"] = searchWord
        
        
        Alamofire.request(.GET, //Метод запроса
                          Constancts.url,//путь к API
                          parameters: params,//параметры запроса
                          encoding: .URL,//как параметры передать. URL - означает, что они будут добавлены к ссылке
                          headers: nil)//дополнительные заголовки запроса
        .responseJSON { (response) in
            print(response)
        }
        
    }
}