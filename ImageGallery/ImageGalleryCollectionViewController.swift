//
//  ImageGalleryCollectionViewController.swift
//  ImageGallery
//
//  Created by Paula Boules on 9/26/18.
//  Copyright © 2018 Paula Boules. All rights reserved.
//

import UIKit

class ImageGalleryCollectionViewController: UICollectionViewController, UICollectionViewDropDelegate {
    
   
    
    var images = [GalleryImage]()
    
    override func viewDidLoad() {
        collectionView?.dataSource = self
        collectionView?.delegate = self
       // collectionView?.dragDelegate = self
        collectionView?.dropDelegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal.init(operation: .copy)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        let destinationPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0 )
        
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
                            print("i can")
                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionPath in
                                self.images.insert(GalleryImage(url: url.imageURL), at: insertionPath.item )
                            })
                        }
                        else  {
                            print("i cannt")
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
            imageCell.fetch(contentOf: images[indexPath.row].url)
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
