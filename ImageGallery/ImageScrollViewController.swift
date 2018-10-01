//
//  ImageScrollViewController.swift
//  ImageGallery
//
//  Created by Paula Boules on 10/1/18.
//  Copyright © 2018 Paula Boules. All rights reserved.
//

import UIKit

class ImageScrollViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
        }
    }
    
    var imageView = UIImageView()
    var image : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        prepareUI()
    }

    
    func prepareUI() {
//
//        imageView.frame.origin = CGPoint(x: view.frame.size.width  / 2 - (image?.size.width)!/2, y:
//            view.frame.size.height / 2 - (image?.size.height)!/2 );
//
        imageView.image = image
        
        imageView.sizeToFit()
        imageView.center = view.center
        scrollView.addSubview(imageView)
        
        scrollView?.contentSize = imageView.frame.size
    }
    
    func  viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}
