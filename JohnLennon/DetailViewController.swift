//
//  DetailViewController.swift
//  JohnLennon
//
//  Created by Peter on 22/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var photo : Photo!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        titleLabel.text = photo.title
        spinner.startAnimating()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        PhotoStore.fetchImage(for: photo).done { image in
            
            self.imageView.image = image
            
            }.ensure {
                self.spinner.stopAnimating()
                
            }.catch{ error in

                print("Unable to retrieve image")
                self.imageView.image = UIImage(named: "placeholderImage")
                
                self.setErrorText()
        }
    }
    
    func setErrorText(){
        let label = UILabel()
        label.text = "Sorry, Could not retrieve image"
        label.textAlignment = .center
        label.font = UIFont(name: "American Typewriter", size: 15)
        label.textColor = UIColor.darkGray
        label.alpha = 0
        
        imageView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: label.superview!.topAnchor, constant: 20)
        
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 1) {
            label.alpha = 1 
        }
        
    }
    
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var topView: UIView!
    
    @IBOutlet var imageView: UIImageView!
    
}
