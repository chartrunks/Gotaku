//
//  CommentsTableViewController.swift
//  Gotaku
//
//  Created by Mac on 6/13/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase


class CommentTableViewCell: UITableViewCell{
    
    @IBOutlet weak var displayPicImageView: UIImageView!
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
}

class CommentsTableViewController: UITableViewController {

    var comments : [Comment] = []
    
    var selectedCellIndexPath: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell

        if selectedCellIndexPath.contains(indexPath){
            cell.commentLabel.numberOfLines = 0
        } else {
            cell.commentLabel.numberOfLines = 5
        }
        
                let comment = comments[comments.count - (1 + indexPath.row)]
                    let picURL = comment.fromDisplayPicURL
                    let user = comment.fromUser
                    let text = comment.text
                    let time = comment.time
                    let rating = comment.rating
        
        cell.userInfoLabel?.text = "\(user) \n\(time)"
        
                    cell.commentLabel.text = "\(text)\n"
        
        if comment.rating == 0.0{
            cell.ratingView.isHidden = true
        } else {
        cell.ratingView.isHidden = false
        cell.ratingView.updateOnTouch = false
            cell.ratingView.filledColor = UIColor(red: 255.0/255.0, green: 146.0/255.0, blue: 0.0, alpha: 1.0)
            cell.ratingView.starMargin = 0
            cell.ratingView.fillMode = 2
            cell.ratingView.emptyBorderColor = UIColor.clear
            cell.ratingView.filledBorderColor = UIColor.clear
            cell.ratingView.rating = rating
            cell.ratingView.emptyColor = UIColor.lightGray
            cell.ratingView.starSize = 25
        }
        
                    Storage.storage().reference(forURL: picURL).getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) in
                        let image = UIImage(data: data!)
                        cell.displayPicImageView.image = image
        
                    })
        
        let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        cell.layer.borderColor = color.cgColor
        cell.layer.borderWidth = 0.2
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedCellIndexPath.count != 0 && selectedCellIndexPath.contains(indexPath){
            selectedCellIndexPath = selectedCellIndexPath.filter {$0 != indexPath}
        } else {
            selectedCellIndexPath.append(indexPath)
        }
        tableView.reloadData()
    }
    }
