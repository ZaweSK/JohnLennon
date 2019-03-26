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

class CollectionViewController: UICollectionViewController

{
    // MARK: - Stored properities
    
    var photoDataSource: PhotoDataSource!
    var imageStore: ImageStore!
    
   
    // MARK: - VC life cycle methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if photoDataSource.photos == nil {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            photoDataSource.fetchPhotos(forCategory: .interestingPhotos).ensure {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                self.collectionView.reloadSections(IndexSet(integer: 0))
                
                }.catch { error in
                    
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
    
            }
        }
    }

   // MARK: UICollectionViewDataSource methods
    
    func isCellDisplayed(for photo: Photo)->CollectionViewCell? {
        
        guard let photoIndex = self.photoDataSource.photos?.index(of: photo) else { return nil}
        
        let photoIndexPath = IndexPath(item: photoIndex, section: 0)
        
        if let cell = collectionView.cellForItem(at: photoIndexPath) as? CollectionViewCell {

            return cell

        } else {

            return nil
        }
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let photo = photoDataSource.photos?[indexPath.row] else {return}
        
        if let image = imageStore.image(for: photo.photoID) {
            
            let photoCell = cell as! CollectionViewCell
            photoCell.update(with: image)
            
            return
        }
        
        ImageFetcher.fetchImage(for: photo).done { image in
            
            self.imageStore.setImage(image, for: photo.photoID)
            
            if let cell = self.isCellDisplayed(for: photo) {
                
                cell.update(with: image)
            }
            
            }.catch {error in
                
                if let cell = self.isCellDisplayed(for: photo) {
                    cell.imageNotFound()
                }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoDataSource.photos?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoItemCell", for: indexPath) as! CollectionViewCell
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            if let indexPath = collectionView.indexPathsForSelectedItems?.first {
                
                let detailVC = segue.destination as! DetailViewController
                
                detailVC.photo = photoDataSource.photos?[indexPath.row]
                detailVC.imageStore = imageStore
            }
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
