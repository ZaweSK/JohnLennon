//
//  PhotoDataSource.swift
//  JohnLennon
//
//  Created by Peter on 25/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import SwiftyJSON

class PhotoDataSource : NSObject  {
    
    var photos : [Photo]?
    
    func fetchPhotos(forCategory category: Category )->Promise<Void>{
        
        return Promise { seal in
            
            let url = FlickrAPI.flickrURL(for: category, with: nil)
            
            var photos = [Photo]()
            
            Alamofire.request(url).validate().responseJSON() { response  in
                
                switch response.result {
                    
                case .success(let value):
                    
                    let resultJSON : JSON = JSON(value)
                    
                    photos = PhotoParser.parse(resultJSON)
                    
                    self.photos = photos
                    
                    seal.fulfill(())
                    
                    
                case .failure(let error):
                    
                    seal.reject(error)
                    
                }
            }
        }
    }
    
}

