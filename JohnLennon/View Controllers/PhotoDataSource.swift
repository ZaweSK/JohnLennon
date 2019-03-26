//
//  PhotoDataSource.swift
//  JohnLennon
//
//  Created by Peter on 25/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import Foundation
import UIKit

class PhotoDataSource : NSObject , UICollectionViewDataSource {
    
    var photos = [Photo]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoItemCell", for: indexPath) as! CollectionViewCell
        
        return cell
    }

}

