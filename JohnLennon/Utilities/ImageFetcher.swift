//
//  ImageFetcher.swift
//  JohnLennon
//
//  Created by Peter on 26/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import Foundation
import PromiseKit

struct ImageFetcher {
    
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
