//
//  Photo.swift
//  JohnLennon
//
//  Created by Peter on 22/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import Foundation

struct Photo {
    
    let title: String
    let remoteURL : URL
    let photoID: String
   
    
    init(title: String, remoteUrl: URL, photoID: String){
        self.title = title
        self.remoteURL = remoteUrl
        self.photoID = photoID
    }
    
}
