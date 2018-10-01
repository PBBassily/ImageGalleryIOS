//
//  ImageGalleryTableViewController.swift
//  ImageGallery
//
//  Created by Paula Boules on 9/27/18.
//  Copyright © 2018 Paula Boules. All rights reserved.
//

import UIKit
import Foundation



class ImageGalleryTableViewController: UITableViewController, ImageGalleryTableViewCellDelegate {
   
    
   
    
    
    
    // Mark: - Initialization
    var collectionVC: ImageGalleryCollectionViewController?
    var galleries = [Gallery]()
    var recentlyDeletedGalleries = [Gallery]()
    var galleriesNames : [String] {
        get{
            return self.galleries.map{$0.name} + self.recentlyDeletedGalleries.map{$0.name}
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Galleries"
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0 : return galleries.count > 0 ? "Your Galleries" : nil // to del if no model
        case 1 : return recentlyDeletedGalleries.count > 0 ? "Recently Deleted" : nil
        default : return nil
        }
    }
    
    // Mark: - Actions
    
    @IBAction func CreateNewGallery(_ sender: UIBarButtonItem) {
        
        galleries.append(Gallery(name: "New Gallery".madeUnique(withRespectTo: galleriesNames)))
        
        tableView.reloadData()
    }
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        guard indexPath.section == 1 else {return nil}
        let deleteAction = UIContextualAction(style: UIContextualAction.Style.destructive, title: "Restore") { _,_,_ in
            tableView.performBatchUpdates({
                let gallery = self.recentlyDeletedGalleries.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                self.galleries.append(gallery)
                tableView.insertRows(at: [IndexPath(row: self.galleries.count-1, section: 0)], with: .fade)
                
                tableView.reloadData()
                
                
            })
        }
        deleteAction.backgroundColor = .green
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    var selectedGallery : Gallery?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else {return }
        //delegate?.galleryIsSelected()
        selectedGallery =  galleries[indexPath.row]
    }

    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 : return galleries.count
        case 1 : return recentlyDeletedGalleries.count
        default : return 0
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryItem", for: indexPath)
        
        if let galleryCell =  cell as? ImageGalleryTableViewCell {
            galleryCell.delegate = self
        switch indexPath.section {
        case 0:
            galleryCell.titleTextField.text  = galleries[indexPath.row].name
        case 1:
            galleryCell.titleTextField.text = recentlyDeletedGalleries[indexPath.row].name
        default:
            break
        }
        }
        return cell
    }
    
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                tableView.performBatchUpdates({
                    let gallery = galleries.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    recentlyDeletedGalleries.append(gallery)
                    tableView.insertRows(at: [IndexPath(row: recentlyDeletedGalleries.count-1, section: 1)], with: .fade)
                   
                })
            } else if indexPath.section == 1 {
                tableView.performBatchUpdates({
                    recentlyDeletedGalleries.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    
                })
                
            }
            
           
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    //MARK: - Cell Delegation
    
    func galleryTitleDidChange(sender: UITableViewCell, newName: String) {
        if let indexPath = tableView.indexPath(for: sender) {
            switch indexPath.section {
            case 0: galleries[indexPath.row].name = newName
            case 1 : recentlyDeletedGalleries[indexPath.row].name = newName
            default : break
            }
        }
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
           collectionVC =  segue.destination as? ImageGalleryCollectionViewController
        
        if segue.identifier == "GallerySelection", let row = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: row){
            if indexPath.section == 0 {
                collectionVC?.gallery = galleries[indexPath.row]
            } else {
                if let splitVC = splitViewController as? GallerySplitViewController {
                    splitVC.showAlert(message: "Restore Gallery")
                    
                }
            }
        }
    }
    
    
}
