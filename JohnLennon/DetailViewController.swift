//
//  DetailViewController.swift
//  JohnLennon
//
//  Created by Peter on 22/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController , UIScrollViewDelegate{

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
            
            self.setZoomParametersForSize(self.scrollView.bounds.size)
            
            self.updateConstraintsForSize(self.view.bounds.size)
            
            }.ensure {
                self.spinner.stopAnimating()
                
            }.catch{ error in

                print("Unable to retrieve image")
                self.imageView.image = UIImage(named: "placeholderImage")
                
                self.setErrorText()
        }
    }
    
    
    func setZoomParametersForSize(_ scrollViewSize: CGSize){
        
        let imageSize = imageView.image!.size
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        
        let minScale = min(widthScale,heightScale)
        scrollView.minimumZoomScale = 1/25
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale
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
    
    @IBOutlet var scrollView: UIScrollView! {
        didSet{
            scrollView.delegate = self
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var topView: UIView!
    
    @IBOutlet var imageView: UIImageView!
    
    
   // scroll view shit
    
    
    @IBOutlet var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewTrailingConstraint: NSLayoutConstraint!

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }

    func updateConstraintsForSize(_ size: CGSize){

        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset - topView.bounds.height
        imageViewBottomConstraint.constant = yOffset

        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset

        view.layoutIfNeeded()
    }
}
