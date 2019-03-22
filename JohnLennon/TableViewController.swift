//
//  TableViewController.swift
//  JohnLennon
//
//  Created by Peter on 22/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var photos = [Photo]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        PhotoStore.fetchPhotos(for: .interestingPhotos)
            
            .done { photos in
                
                self.photos =  photos
                
                self.tableView.reloadData()
                
            }.ensure {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
            }.catch { error in
                
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
        }
        
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath)
        
        let photo = photos[indexPath.row]
        cell.textLabel?.text = photo.title
        
        return cell
    }
}
