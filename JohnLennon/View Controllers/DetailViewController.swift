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
    var imageStore : ImageStore!
    
    // MARK: - @IBOutlests
    
   

    
    

    @IBAction func goBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var topView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
        // Image in scroll view constraints:
    
    @IBOutlet var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - VC Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        titleLabel.text = photo.title
        spinner.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let image = imageStore.image(for: photo.photoID) {
            self.spinner.stopAnimating()
            imageView.image = image
            centerImage()
            return
        }
        
        ImageFetcher.fetchImage(for: photo).done { image in
            
            self.imageStore.setImage(image, for: self.photo.photoID)
            
            self.imageView.image = image
            
            }.ensure {
                
                self.spinner.stopAnimating()
                
                if self.imageView.image == nil {
                    
                     self.imageView.image = UIImage(named: "placeholderImage")
                }
                
               self.centerImage()
                
            }.catch{ error in
                
                self.setErrorText()
        }
    }
    
    // MARK: Image centering, zooming
    
    func centerImage(){
        
        setZoomParametersForSize(self.scrollView.bounds.size)
        
        updateConstraintsForSize(self.view.bounds.size)
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
    
    func updateConstraintsForSize(_ size: CGSize){
        
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset - topView.bounds.height
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
    
    
    // MARK: - Error Handling
    
    func setErrorText(){
        let label = UILabel()
        label.text = "Sorry, Could not retrieve image"
        label.textAlignment = .center
        label.font = UIFont(name: "American Typewriter", size: 60)
        label.textColor = UIColor.darkGray
        label.alpha = 0
        
        imageView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: label.superview!.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: label.superview!.topAnchor, constant: 20).isActive = true
        
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 1) {
            label.alpha = 1 
        }
        
    }
    
    // MARK: - Scroll View Delegate methods
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
}
