//
//  TableViewController.swift
//  JohnLennon
//
//  Created by Peter on 22/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var photoDataSource: PhotoDataSource!
    var imageStore: ImageStore!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if photoDataSource.photos == nil {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            photoDataSource.fetchPhotos(forCategory: .interestingPhotos).ensure {
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                self.tableView.reloadData()
                
                }.catch { error in
                    
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(alertAction)
                    self.present(alertController, animated: true, completion: nil)
                    
            }
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoDataSource.photos?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath)
        
        if let photo = photoDataSource.photos?[indexPath.row] {
            
            cell.textLabel?.text = photo.title
        }
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            if let index = tableView.indexPathForSelectedRow {
                
                let detailVC = segue.destination as! DetailViewController
                
                detailVC.photo = photoDataSource.photos?[index.row]
                detailVC.imageStore = imageStore
            }
        }
    }
    
}


