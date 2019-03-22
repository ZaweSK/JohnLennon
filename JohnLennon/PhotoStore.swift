//
//  PhotoStore.swift
//  JohnLennon
//
//  Created by Peter on 22/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftyJSON

class PhotoStore
{
    static func fetchPhotos(for category: Category )->Promise<JSON>{
        
        return Promise { seal in
            
            let url = FlickrAPI.flickrURL(for: category, with: nil)
            
            Alamofire.request(url).validate().responseJSON() { response  in
                
                print(response.request)
                
                switch response.result {
                    
                case .success(let value):
                    
                    let resultJSON : JSON = JSON(value)
                    
                    seal.fulfill(resultJSON)
                    
                    
                case .failure(let error):
                    
                    seal.reject(error)
                    
                }
            }
        }
    }
    
    
    static func parsePhotosJSON(_ json: JSON){
        
    }
    
}
