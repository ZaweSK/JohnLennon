# JohnLennon
<img align="right" src="johnlennon.jpg">

## Overview


Apps gets the latest images from Flickr and displays them either in a 
collection view or table view. These two choices are avaliable via TabBarController.
Both the collection view and table view share the same source.
Each image can be viewed as a detail, which displays an image as a scroll view and allows user to zoom and scroll on it.
Once the image is downloaded, it is put in a cache.

(it's my app, I can name it how I want)

<img align="right" src="johnLennon.gif">



## Implemented bits
* download data as JSON asynchronously using PromiseKit, Alamofire
* parsing the JSON file using SwiftyJSON
* working with UITableView and UICollectionView
* using dependency injection 
* using custom made collection view cell
* fetching images for collection view cell asynchronously so that the UI won't get blocked
* implementing scroll view, zooming, centering the image in scroll view, scaling the image so it fits the screen
* caching images using NSCache
* building URL with URLComponents and QueryItems array
* creating custom Promises which are run on a background thread
* using CollectionViewDelegateFlowLayput methods to customize the look of collection view
* usin traitsCollection to detect size class
* ...
