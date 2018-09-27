//
//  GallerySplitViewController.swift
//  ImageGallery
//
//  Created by Paula Boules on 9/27/18.
//  Copyright © 2018 Paula Boules. All rights reserved.
//

import UIKit

class GallerySplitViewController: UISplitViewController{
    


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if  self.preferredDisplayMode != .primaryOverlay {
            self.preferredDisplayMode = .primaryOverlay
        }
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
