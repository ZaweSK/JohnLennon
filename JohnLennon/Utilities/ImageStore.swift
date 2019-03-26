//
//  ImageStore.swift
//  JohnLennon
//
//  Created by Peter on 26/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import Foundation
import UIKit

class ImageStore {
    
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, for key: String){
        cache.setObject(image,forKey: key as NSString)
    }
    
    func image(for key: String)->UIImage?{
        return cache.object(forKey: key as NSString)
    }
    
    func deleteImage(for key: NSString){
        cache.removeObject(forKey: key)
    }
    
}
