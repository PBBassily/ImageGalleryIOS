//
//  ImageCollectionViewCell.swift
//  ImageGallery
//
//  Created by Paula Boules on 9/26/18.
//  Copyright © 2018 Paula Boules. All rights reserved.
//

import UIKit

protocol ImageCollectionViewCellDelegate : class {
    func didLoadImage()
}

class ImageCollectionViewCell: UICollectionViewCell {

    weak var delegate : ImageCollectionViewCellDelegate?
    
    
    
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    func fetch(contentOf imageURL : URL) {
        
            imageView.image = nil
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: imageURL)
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                    
                    if let imageData  = urlContents{
                        print("i got \(imageURL)")
                        self?.imageView.image = UIImage(data: imageData)
                        self?.delegate?.didLoadImage()
                }
            }
        }
        
        
        
    }
    
    
}
