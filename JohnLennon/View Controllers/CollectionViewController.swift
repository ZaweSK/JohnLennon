//
//  CollectionViewController.swift
//  JohnLennon
//
//  Created by Peter on 25/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire


private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    var photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        PhotoFetcher.fetchPhotos(forCategory: .interestingPhotos)
            
            .done { photos in
                
                self.photoDataSource.photos = photos
                
            }.ensure {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                self.collectionView.reloadSections(IndexSet(integer: 0))
                
            }.catch { error in
                
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
        }
    }

   // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(#function)

        let photo = photoDataSource.photos[indexPath.row]
    
        PhotoFetcher.fetchImage(for: photo).done { image in

            if let cell = self.isCellDisplayed(for: photo) {

                cell.update(with: image)
            }

            }.catch {error in
                
                if let cell = self.isCellDisplayed(for: photo) {
                    cell.imageNotFound()
                }
        }
    }
    
    func isCellDisplayed(for photo: Photo)->CollectionViewCell? {
        
        guard let photoIndex = self.photoDataSource.photos.index(of: photo) else { return nil}
        
        let photoIndexPath = IndexPath(item: photoIndex, section: 0)
        
        if let cell = collectionView.cellForItem(at: photoIndexPath) as? CollectionViewCell {

            return cell

        }else {

            return nil
        }
    }
}





// MARK: - Collection View Flow Layout delegate methods

extension CollectionViewController:  UICollectionViewDelegateFlowLayout {
    
    
    struct Constants {
        
        static let collectionViewInset: CGFloat = 5
        static let itemsHorizontalSpacing: CGFloat = 2
        static let itemsVerticalSpacing : CGFloat = 2
    }
    
    var numbersOfItemsInRow: Int {
        return inLandscape ? 5 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsContainerWidth = view.bounds.width - totalHorizontalPadding
        
        let itemWidth = (itemsContainerWidth - totalItemsHorizontalSpacing) / CGFloat(numbersOfItemsInRow)
        
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
        return CGFloat((numbersOfItemsInRow - 1)) * Constants.itemsHorizontalSpacing
    }
    
    var inLandscape : Bool {
        switch traitCollection.verticalSizeClass {
        case .compact:
            return true
        case .regular:
            return false
        default: return false
        }
    }
    
}
