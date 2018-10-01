//
//  ImageGalleryTableViewCell.swift
//  ImageGallery
//
//  Created by Paula Boules on 10/1/18.
//  Copyright © 2018 Paula Boules. All rights reserved.
//

import UIKit

protocol ImageGalleryTableViewCellDelegate : class {
    func galleryTitleDidChange(sender : UITableViewCell,newName: String)
}


class ImageGalleryTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    weak var delegate : ImageGalleryTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandler))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
        
        titleTextField.delegate = self
        titleTextField.isEnabled = false
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @objc func doubleTapHandler() {
        
        titleTextField.isEnabled = true
       
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.text = (titleTextField.text?.isEmpty)! ? "Untitled" : titleTextField.text
        titleTextField.isEnabled = false
        titleTextField.resignFirstResponder()
        delegate?.galleryTitleDidChange(sender: self ,newName
            : textField.text!)
        return true
    }
    
}
