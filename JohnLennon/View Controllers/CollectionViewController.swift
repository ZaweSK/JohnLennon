//
//  CollectionViewController.swift
//  JohnLennon
//
//  Created by Peter on 25/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        PhotoFetcher.fetchPhotos(forCategory: .interestingPhotos)
            
            .done { photos in
                
                self.photos =  photos
                
                self.collectionView.reloadData()
                
            }.ensure {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            }.catch { error in
                
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
        }
    }



    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoItemCell", for: indexPath)
    
        cell.backgroundColor = UIColor.blue
    
        return cell
    }
    
    
    
    
    
    
    // MARK: - Collection View Flow Layout delegate methods
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsContainerWidth = view.bounds.width - totalHorizontalPadding
        
        let itemWidth = (itemsContainerWidth - totalItemsHorizontalSpacing) / CGFloat(Constants.numbersOfItemsInRow)
        
        return CGSize(width: itemWidth, height: itemWidth)

    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.itemsHorizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.itemsVerticalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let inset = Constants.collectionViewInset
        
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    

    
    var totalHorizontalPadding: CGFloat {
        return Constants.collectionViewInset * 2
    }
    
    var totalItemsHorizontalSpacing: CGFloat {
        return CGFloat((Constants.numbersOfItemsInRow - 1)) * Constants.itemsHorizontalSpacing
    }
    
    struct Constants {
        
        static let collectionViewInset: CGFloat = 5
        static let numbersOfItemsInRow  = 3
        static let itemsHorizontalSpacing: CGFloat = 2
        static let itemsVerticalSpacing : CGFloat = 2
    }
    

}
