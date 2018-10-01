//
//  ImageGalleryCollectionViewController.swift
//  ImageGallery
//
//  Created by Paula Boules on 9/26/18.
//  Copyright © 2018 Paula Boules. All rights reserved.
//

import UIKit

class ImageGalleryCollectionViewController: UICollectionViewController, UICollectionViewDropDelegate, UICollectionViewDragDelegate,ImageCollectionViewCellDelegate,UICollectionViewDelegateFlowLayout{
    
  
    var gallery : Gallery? {
        didSet {
            collectionView?.reloadData()
            collectionView?.makeUIEnabled()
        }
    }
    
    var images : [GalleryImage]? {
        get {
            return gallery?.images
        }
        
        set {
            gallery?.images = newValue!
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.dragDelegate = self
        collectionView?.dropDelegate = self
        
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(scaler(_:)))
        view.addGestureRecognizer(pinch)
        
        if (gallery == nil){
            collectionView?.makeUIDisabled()
        }
        
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
        return session.canLoadObjects(ofClass: NSURL.self)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        let isInCollectionViewContext = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        
        
        return UICollectionViewDropProposal(operation: isInCollectionViewContext ? .move : .copy, intent: .insertAtDestinationIndexPath)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        let destinationPath = coordinator.destinationIndexPath ?? IndexPath(item: (images?.count)!, section: 0 )
        
        for item in coordinator.items {
            
            if let sourcePath = item.sourceIndexPath {
                // local drop
                print("local drop")
                if let url = (item.dragItem.localObject as? URL) {
                    collectionView.performBatchUpdates({
                        images?.remove(at: sourcePath.item)
                        images?.insert(GalleryImage(url: url), at: destinationPath.item)
                        collectionView.deleteItems(at: [sourcePath])
                        collectionView.insertItems(at: [destinationPath])
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
                                self.images?.insert(GalleryImage(url: url.imageURL), at: insertionPath.item )
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
        
        if (self.images?.count == 0) {
            self.collectionView?.setEmptyMessage("Your gallery is Empty!")
        } else {
            self.collectionView?.restore()
        }
        return self.images?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        
        if let imageCell = cell as? ImageCollectionViewCell {
            imageCell.delegate = self
            imageCell.fetch(contentOf: images![indexPath.row].url)
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
    
    func dragItems(at indexPath :IndexPath ) -> [UIDragItem]{
        if let url  = (collectionView?.cellForItem(at: indexPath) as? ImageCollectionViewCell)?.imageUrl  as NSURL? {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: url))
            dragItem.localObject = url // no need for sessions lifeCycle because we are in the same app
            return [dragItem]
        }
        return []
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        
        return dragItems(at: indexPath)
    }
    
    
    
}
