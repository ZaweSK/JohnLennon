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

class PhotoFetcher
    
{
    // MARKL: - Fetching Photos JSON
    
    static func fetchPhotos(forCategory category: Category )->Promise<[Photo]>{
        
        return Promise { seal in
            
            let url = FlickrAPI.flickrURL(for: category, with: nil)
            
            var photos = [Photo]()
            
            Alamofire.request(url).validate().responseJSON() { response  in
                
                switch response.result {
                    
                case .success(let value):
                    
                    let resultJSON : JSON = JSON(value)
                    
                    photos = parse(resultJSON)
                    
                    seal.fulfill(photos)
                    
                    
                case .failure(let error):
                    
                    seal.reject(error)
                    
                }
            }
        }
    }
    
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
    
    
    // MARK: - Fetching image asynchronously
    
    static func fetchImage(for photo: Photo)->Promise<UIImage>{
        
        let bgq = DispatchQueue.global(qos: .userInitiated)
        
        return Promise<UIImage> { seal in
            
            bgq.async {
                
                do {
                    
                    let imageData =  try Data(contentsOf: photo.remoteURL)
                    
                    if let image = UIImage(data: imageData){
                        
                        seal.fulfill(image)
                        
                    }else {
                        
                        seal.reject(PhotoFetchError.unableToCreatePhotoFromData)
                    }
                    
                } catch {
                    
                    seal.reject(error)
                }
                
            }
        }
    }
}


enum PhotoFetchError: Error {
    case unableToCreatePhotoFromData
}