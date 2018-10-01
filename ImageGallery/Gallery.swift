//
//  Gallery.swift
//  ImageGallery
//
//  Created by Paula Boules on 9/27/18.
//  Copyright © 2018 Paula Boules. All rights reserved.
//

import Foundation


class Gallery {
    var name : String
    var images = [GalleryImage]()
    
    init(name: String, images: [GalleryImage]) {
        self.name = name
        self.images = images
    }
    init(name: String) {
        self.name = name
    }
}
