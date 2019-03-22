//
//  FlickrAPI.swift
//  JohnLennon
//
//  Created by Peter on 22/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import Foundation

enum Category:String{
    case interestingPhotos = "flickr.interestingness.getList"
    case recentPhotos = "flickr.photos.getRecent"
}


struct FlickrAPI{
    
    private static let API_KEY = "a6d819499131071f158fd740860a5a88"
    private static let baseURL =  "https://api.flickr.com/services/rest"
    
    private static func flickrURL(for category: Category, with params: [String:String]?)->URL{
        
        var components = URLComponents(string: baseURL)!
        
        let baseParams = [
            "method" : category.rawValue,
            "format" : "json",
            "nojsoncallback" : "1",
            "api_key" : API_KEY,
            "extras" : "url_h,date_taken",
            
        ]
        
        var queryItems = [URLQueryItem]()
        
        for (key,value) in baseParams {
            let queryItem = URLQueryItem(name: key, value: value)
            queryItems.append(queryItem)
        }
        
        if let additionalParams = params {
            
            for (key,value) in additionalParams {
                let queryItem = URLQueryItem(name: key, value: value)
                queryItems.append(queryItem)
            }
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
    
}
