//
//  CollectionViewCell.swift
//  JohnLennon
//
//  Created by Peter on 25/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBOutlet var imageView: UIImageView!
    
    
        func update(with image: UIImage?){
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        }else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        update(with: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        update(with: nil)
    }
    
}
