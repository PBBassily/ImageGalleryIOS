//
//  ImageGalleryTableViewController.swift
//  ImageGallery
//
//  Created by Paula Boules on 9/27/18.
//  Copyright © 2018 Paula Boules. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController {
    
    
    var galleries = [Gallery]()
    var recentlyDeletedGalleries = [Gallery]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        galleries.append(Gallery(name: "gallery1"))
        galleries.append(Gallery(name: "gallery2"))
        galleries.append(Gallery(name: "gallery3"))
        
        recentlyDeletedGalleries.append(Gallery(name: "gallery11"))
        recentlyDeletedGalleries.append(Gallery(name: "gallery21"))
        recentlyDeletedGalleries.append(Gallery(name: "gallery32"))
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0 : return "Your Galleries"
        case 1 : return "Recently Deleted"
        default : return ""
        }
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
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = galleries[indexPath.row].name
        case 1:
            cell.textLabel?.text = recentlyDeletedGalleries[indexPath.row].name
        default:
            break
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
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
