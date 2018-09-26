//
//  ImageGalleryCollectionViewController.swift
//  ImageGallery
//
//  Created by Paula Boules on 9/26/18.
//  Copyright © 2018 Paula Boules. All rights reserved.
//

import UIKit

class ImageGalleryCollectionViewController: UICollectionViewController, UICollectionViewDropDelegate, ImageCollectionViewCellDelegate,UICollectionViewDelegateFlowLayout {
    
    
    
    
    
    var images = [GalleryImage]()
    
    override func viewDidLoad() {
        collectionView?.dataSource = self
        collectionView?.delegate = self
        // collectionView?.dragDelegate = self
        collectionView?.dropDelegate = self
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(scaler(_:)))
        view.addGestureRecognizer(pinch)
        
        
    }
  @objc  func scaler(_ gestureRecognizer : UIPinchGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            Constants.FIXED_CELL_WIDTH = Constants.FIXED_CELL_WIDTH*gestureRecognizer.scale
            gestureRecognizer.scale = 1.0
        }
    
    flowLayout?.invalidateLayout()
    }
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal.init(operation: .copy)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        let destinationPath = coordinator.destinationIndexPath ?? IndexPath(item: images.count, section: 0 )
        
        for item in coordinator.items {
            
            if let sourcePath = item.sourceIndexPath {
                // local drop
                print("local drop")
                if let attributedString = (item.dragItem.localObject as? NSAttributedString) {
                    collectionView.performBatchUpdates({
                        
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationPath)
                    
                }
                
            }else  {
                
                print("outsource")
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationPath, reuseIdentifier: "PlaceHolderCell"))
                
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self, completionHandler: { (provider, error) in
                    DispatchQueue.main.async {
                        
                        if let url = provider as? URL {
                            print("cv can drop image")
                            //self.flowLayout?.invalidateLayout()
                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionPath in
                                self.images.insert(GalleryImage(url: url.imageURL), at: insertionPath.item )
                            })
                        }
                        else  {
                            print("cv cant drop image")
                            placeholderContext.deletePlaceholder()
                        }
                    }
                    
                }
                )
                
            }
            
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.delegate = self
            imageCell.fetch(contentOf: images[indexPath.row].url)
        }
        
        return cell
    }
    
    var flowLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    func didLoadImage() {
    
        
        flowLayout?.invalidateLayout()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("update cell layout")
        let cell = collectionView.cellForItem(at: indexPath)
        
        
        let imageCell = cell as? ImageCollectionViewCell
        
        if let image = imageCell?.imageView.image {
            
            let aspectRatio = image.size.width / image.size.height
            let newHeight = CGFloat(Constants.FIXED_CELL_WIDTH) / aspectRatio
        
            return CGSize(width: Constants.FIXED_CELL_WIDTH, height: newHeight)
    } else {
    return CGSize(width: Constants.FIXED_CELL_WIDTH , height: Constants.FIXED_CELL_HEIGHT)
    }
    
}

}
