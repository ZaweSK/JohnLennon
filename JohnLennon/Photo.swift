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
    let dateTaken: Date
    
    init(title: String, remoteUrl: URL, photoID: String, dateTaken: Date){
        self.title = title
        self.remoteURL = remoteUrl
        self.photoID = photoID
        self.dateTaken = dateTaken
    }
    
}
