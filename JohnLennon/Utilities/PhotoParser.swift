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

class PhotoParser
    
{
    // MARK: - Parsing Photos JSON
    
    static func parse(_ json: JSON)->[Photo]{
        
        guard let photosArrayJSON = json["photos"]["photo"].array else { return []}
        
        var photosArray = [Photo]()
        
        for photoJSON in photosArrayJSON {
            
            if let photo = parseSinglePhoto(photoJSON) {
                
                photosArray.append(photo)
            }
        }
        return photosArray
    }
    
    static func parseSinglePhoto(_ json: JSON)->Photo? {
        
        guard
            let title = json["title"].string,
            let id = json["id"].string,
            let stringURL = json["url_h"].string,
            let url = URL(string: stringURL)
            else {
                return nil
        }
        
        return Photo(title: title, remoteUrl: url, photoID: id)
    }
}

