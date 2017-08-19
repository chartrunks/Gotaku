//
//  ViewLocationViewController.swift
//  Gotaku
//
//  Created by Mac on 6/7/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import SafariServices


class LocCommentTableViewCell: UITableViewCell{
    
    @IBOutlet weak var displayPicImageView: UIImageView!
    @IBOutlet weak var userInfoLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
}

class ViewLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var loc : Location = Location()
    
    var event : Event = Event()
    
    var commentIndex = 0
    
    var comments : [Comment] = []
    
    var addresses : [String] = []
    
    var cosmosView = CosmosView()
    
    var currentRating = 0.0
    
    var rating: Bool = false
    
    var selectedCellIndexPath: [IndexPath] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.autoresizesSubviews = true
        
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 300)
        let headerImageView = UIImageView(frame: frame)
        headerImageView.contentMode = .scaleAspectFill
        let image : UIImage = UIImage(named: "mashu")!
        headerImageView.image = image
        tableView.tableHeaderView = headerImageView
        
        
        
        if loc.locID != ""{
            Database.database().reference().child("locationInfo").child("locations").child((loc.locID)).child("comments").observe(.childAdded, with: { (snapshot) in
                let comment = Comment()
                comment.fromDisplayPicURL = (snapshot.value as! NSDictionary)["fromDisplayPicURL"] as! String
                comment.fromUser = (snapshot.value as! NSDictionary)["fromUser"] as! String
                comment.text = (snapshot.value as! NSDictionary)["text"] as! String
                comment.time = (snapshot.value as! NSDictionary)["time"] as! String
                if snapshot.hasChild("rating"){
                    comment.rating = (snapshot.value as! NSDictionary)["rating"] as! Double
                }
                self.comments.append(comment)
                self.tableView.reloadData()
            })
        } else {
            addresses = event.address
            Database.database().reference().child("eventInfo").child("events").child(event.eventID).child("comments").observe(.childAdded, with: { (snapshot) in
                let comment = Comment()
                comment.fromDisplayPicURL = (snapshot.value as! NSDictionary)["fromDisplayPicURL"] as! String
                comment.fromUser = (snapshot.value as! NSDictionary)["fromUser"] as! String
                comment.text = (snapshot.value as! NSDictionary)["text"] as! String
                comment.time = (snapshot.value as! NSDictionary)["time"] as! String
                if snapshot.hasChild("rating"){
                    comment.rating = (snapshot.value as! NSDictionary)["rating"] as! Double
                }
                self.comments.append(comment)
                self.tableView.reloadData()
            })
        }
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150.0
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comments.count == 0{
            return 11
        }else if comments.count == 1{
            return 11
        } else if comments.count == 2 {
            return 12
        } else if comments.count == 3 {
            return 13
        } else if comments.count == 4 {
            return 14
        } else if comments.count == 5 {
            return 15
        } else {
            return 16 //need a view more
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if loc.locID != ""{
        return loc.name
        }
        return event.name
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 40
        }
        tableView.estimatedRowHeight = 150.0
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //Makes it so last selected is no longer highlighted after selection
        if indexPath.row == 3{
            openURL((loc.websiteURL))
            
        } else if indexPath.row == 8{
            if cosmosView.rating != 0{
                rating = true
                
                if loc.locID != ""{
                Database.database().reference().child("locationInfo").child("locations").child((loc.locID)).observeSingleEvent(of: .value, with: { (snapshot) in
                    if (self.loc.ratings.count) > 0{
                        if !(self.loc.ratedUsers.contains((Auth.auth().currentUser?.uid)!)){
                            
                            //Calculate rating and adjust location
                            self.loc.ratings.append(self.cosmosView.rating)
                            var rating = 0.0
                            var ratingNum = 0
                            for dblRating in (self.loc.ratings){
                                rating += dblRating
                                ratingNum += 1
                            }
                            rating = rating / (Double(ratingNum))
                            self.loc.rating = rating
                            self.loc.ratedUsers.append((Auth.auth().currentUser?.uid)!)
                            
                            //Change database values
                            var ratings = (snapshot.value as! NSDictionary)["ratings"] as! String
                            ratings.append(" \(self.cosmosView.rating)")
                            var ratedUsers = (snapshot.value as! NSDictionary)["ratedUsers"] as! String
                            ratedUsers.append(" \((Auth.auth().currentUser?.uid)!)")
                            
                            Database.database().reference().child("locationInfo").child("locations").child((self.loc.locID)).child("ratings").setValue(ratings)
                            Database.database().reference().child("locationInfo").child("locations").child((self.loc.locID)).child("rank").setValue(rating)
                            Database.database().reference().child("locationInfo").child("locations").child((self.loc.locID)).child("ratedUsers").setValue(ratedUsers)
                        }
                    } else {
                        Database.database().reference().child("locationInfo").child("locations").child((self.loc.locID)).child("ratings").setValue("\(self.cosmosView.rating)")
                        Database.database().reference().child("locationInfo").child("locations").child((self.loc.locID)).child("rank").setValue(self.cosmosView.rating)
                        Database.database().reference().child("locationInfo").child("locations").child((self.loc.locID)).child("ratedUsers").setValue(Auth.auth().currentUser?.uid)
                        self.loc.rating = self.cosmosView.rating
                        self.loc.ratings = [self.cosmosView.rating]
                        self.loc.ratedUsers = [(Auth.auth().currentUser?.uid)!]
                    }
                })
                } else {
                    Database.database().reference().child("eventInfo").child("events").child(event.eventID).observeSingleEvent(of: .value, with: { (snapshot) in
                        if (self.event.ratings.count) > 0{
                            if !(self.event.ratedUsers.contains((Auth.auth().currentUser?.uid)!)){
                                
                                //Calculate rating and adjust location
                                self.event.ratings.append(self.cosmosView.rating)
                                var rating = 0.0
                                var ratingNum = 0
                                for dblRating in (self.event.ratings){
                                    rating += dblRating
                                    ratingNum += 1
                                }
                                rating = rating / (Double(ratingNum))
                                self.event.rating = rating
                                self.event.ratedUsers.append((Auth.auth().currentUser?.uid)!)
                                
                                //Change database values
                                var ratings = (snapshot.value as! NSDictionary)["ratings"] as! String
                                ratings.append(" \(self.cosmosView.rating)")
                                var ratedUsers = (snapshot.value as! NSDictionary)["ratedUsers"] as! String
                                ratedUsers.append(" \((Auth.auth().currentUser?.uid)!)")
                                
                                Database.database().reference().child("eventInfo").child("events").child((self.event.eventID)).child("ratings").setValue(ratings)
                                Database.database().reference().child("eventInfo").child("events").child((self.event.eventID)).child("rank").setValue(rating)
                                Database.database().reference().child("eventInfo").child("events").child((self.event.eventID)).child("ratedUsers").setValue(ratedUsers)
                            }
                        } else {
                            Database.database().reference().child("eventInfo").child("events").child(self.event.eventID).child("ratings").setValue("\(self.cosmosView.rating)")
                            Database.database().reference().child("eventInfo").child("events").child(self.event.eventID).child("rank").setValue(self.cosmosView.rating)
                            Database.database().reference().child("eventInfo").child("events").child(self.event.eventID).child("ratedUsers").setValue(Auth.auth().currentUser?.uid)
                            self.event.rating = self.cosmosView.rating
                            self.event.ratings = [self.cosmosView.rating]
                            self.event.ratedUsers = [(Auth.auth().currentUser?.uid)!]
                        }
                    })

                }
                
                if !(self.loc.ratedUsers.contains((Auth.auth().currentUser?.uid)!)){
                    self.performSegue(withIdentifier: "writeCommentSegue", sender: nil)
                }
            }
        } else if (comments.count == 0 && indexPath.row == 10) || (comments.count == 1 && indexPath.row == 10) ||
            (comments.count == 2 && indexPath.row == 11) ||
            (comments.count == 3 && indexPath.row == 12) ||
            (comments.count == 4 && indexPath.row == 13) ||
            (comments.count == 5 && indexPath.row == 14) ||
            (comments.count > 5 && indexPath.row == 15){
            self.performSegue(withIdentifier: "writeCommentSegue", sender: nil)
        } else if comments.count > 0 && indexPath.row == 9 ||
            comments.count > 1 && indexPath.row == 10 ||
            comments.count > 2 && indexPath.row == 11 ||
            comments.count > 3 && indexPath.row == 12 ||
            comments.count > 4 && indexPath.row == 13{
            if selectedCellIndexPath.count != 0 && selectedCellIndexPath.contains(indexPath){
                selectedCellIndexPath = selectedCellIndexPath.filter {$0 != indexPath}
            } else {
                selectedCellIndexPath.append(indexPath)
            }
            tableView.reloadData()
        } else if comments.count > 5 && indexPath.row == 14{
            self.performSegue(withIdentifier: "viewAllSegue", sender: nil)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let i = indexPath.row
        
        if loc.locID != ""{
        if i == 0{
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor(red: 255.0/255.0, green: 146.0/255.0, blue: 0.0, alpha: 1.0)
            cell.textLabel?.textColor = UIColor.black
            let newView = CosmosView(frame: CGRect(x: 20, y: 10, width: 150, height: 50))
            newView.updateOnTouch = false
            newView.filledColor = UIColor.red
            newView.starMargin = 0
            newView.fillMode = 2
            newView.emptyBorderColor = UIColor.clear
            newView.filledBorderColor = UIColor.clear
            newView.rating = (loc.rating)
            let roundedRating = round(100.0 * (loc.rating)) / 100.0
            newView.text = "  \(roundedRating)   Comments: \(comments.count) "
            newView.textColor = UIColor.black
            newView.emptyColor = UIColor.lightGray
            newView.starSize = 25
            newView.textSize = 14
            cell.contentView.addSubview(newView)
            return cell
        }else if i == 1{
            let cell = UITableViewCell()
            let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            cell.layer.borderColor = color.cgColor
            cell.layer.borderWidth = 0.2
            cell.textLabel?.text = loc.description
            return cell
        } else if i == 2{
            let cell = UITableViewCell()
            let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            cell.layer.borderColor = color.cgColor
            cell.layer.borderWidth = 0.2
            cell.textLabel?.text = loc.address
            cell.imageView?.image = UIImage(named: "map")
            
            let itemSize = CGSize(width: 20, height: 20)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
            let imageRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
            cell.imageView!.image?.draw(in: imageRect)
            cell.imageView!.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return cell
            
        } else if i == 3 {
            let cell = UITableViewCell()
            let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            cell.layer.borderColor = color.cgColor
            cell.layer.borderWidth = 0.2
            cell.textLabel?.text = loc.websiteURL
            cell.imageView?.image = UIImage(named: "link")
            
            let itemSize = CGSize(width: 20, height: 20)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
            let imageRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
            cell.imageView!.image?.draw(in: imageRect)
            cell.imageView!.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return cell
        } else if i == 4{
            let cell = UITableViewCell()
            let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            cell.layer.borderColor = color.cgColor
            cell.layer.borderWidth = 0.2
            var times = ""
            for time in (loc.times){
                times = times + "\n" + time
            }
            if times == ""{
                cell.textLabel?.text = "No info. Click here to add!"
            } else {
                cell.textLabel?.text = times
            }
            cell.imageView?.image = UIImage(named: "hours")
            
            let itemSize = CGSize(width: 20, height: 20)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
            let imageRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
            cell.imageView!.image?.draw(in: imageRect)
            cell.imageView!.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return cell
        } else if i == 5{
            let cell = UITableViewCell()
            let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            cell.layer.borderColor = color.cgColor
            cell.layer.borderWidth = 0.2
            var types = ""
            for type in (loc.goodsTypes){
                types = types + ", " + type
            }
            if types == ""{
                cell.textLabel?.text = "Type(s) of Goods: No info. Click here to add!"
            } else {
                cell.textLabel?.text = "Type(s) of Goods: \(types)"
            }
            return cell
        } else if i == 6{
            let cell = UITableViewCell()
            let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            cell.layer.borderColor = color.cgColor
            cell.layer.borderWidth = 0.2
            var titles = ""
            for title in (loc.relatedTitles){
                titles = titles + ", " + title
            }
            if titles == ""{
                cell.textLabel?.text = "Goods from: No info. Click here to add!"
            } else{
                cell.textLabel?.text = "Goods from: \(titles)"
            }
            return cell
        } else if i == 7{
            let cell = UITableViewCell()
            let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            cell.layer.borderColor = color.cgColor
            cell.layer.borderWidth = 0.2
            cell.textLabel?.text = "Last updated: \(loc.lastUpdated)"
            cell.textLabel?.textColor = UIColor.black
            cell.isUserInteractionEnabled = false
            return cell
        } else if i == 8{
            let cell = UITableViewCell()
            let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            cell.layer.borderColor = color.cgColor
            cell.layer.borderWidth = 0.2
            cell.backgroundColor = UIColor(red: 255.0/255.0, green: 146.0/255.0, blue: 0.0, alpha: 1.0)
            cell.textLabel?.textColor = UIColor.black
            let newView = CosmosView(frame: CGRect(x: cell.center.x - 43.75, y: 5, width: 150, height: 45))
            if let index = loc.ratedUsers.index(of: (Auth.auth().currentUser?.uid)!){
                newView.updateOnTouch = false
                newView.rating = (loc.ratings[index])
                cell.isUserInteractionEnabled = false
            } else {
                newView.updateOnTouch = true
                newView.rating = 0
            }
            
            newView.filledColor = UIColor.red
            newView.starMargin = 0
            newView.fillMode = 0
            newView.emptyBorderColor = UIColor.clear
            newView.filledBorderColor = UIColor.clear
            newView.emptyColor = UIColor.lightGray
            newView.starSize = 35
            cell.contentView.addSubview(newView)
            cosmosView = newView
            return cell
        } else if (comments.count == 0 && indexPath.row == 9){
            let cell = UITableViewCell()
            cell.textLabel?.text = "No comments have been left so far. Be the first and leave one now!"
            return cell
        } else if (comments.count == 0 && indexPath.row == 10) || (comments.count == 1 && indexPath.row == 10) || (comments.count == 2 && indexPath.row == 11) || (comments.count == 3 && indexPath.row == 12) || (comments.count == 4 && indexPath.row == 13) || (comments.count == 5 && indexPath.row == 14) ||
            (comments.count > 5 && indexPath.row == 15){
            let cell = UITableViewCell()
            cell.textLabel?.text = "Leave a comment!"
            cell.backgroundColor = UIColor(red: 255.0/255.0, green: 146.0/255.0, blue: 0.0, alpha: 1.0)
            cell.textLabel?.textColor = UIColor.black
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            return cell
        } else if comments.count > 0 && indexPath.row == 9{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocCommentCell") as! LocCommentTableViewCell
            
            if selectedCellIndexPath.contains(indexPath){
                cell.commentLabel.numberOfLines = 0
            } else {
                cell.commentLabel.numberOfLines = 5
            }
            
            let comment = comments[comments.count - 1]
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
            
            //cell.isUserInteractionEnabled = false
            Storage.storage().reference(forURL: picURL).getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) in
                let image = UIImage(data: data!)
                cell.displayPicImageView.image = image
                
            })
            
            let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            cell.layer.borderColor = color.cgColor
            cell.layer.borderWidth = 0.2
            return cell
        } else if comments.count > 1 && indexPath.row == 10{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocCommentCell") as! LocCommentTableViewCell
            
            if selectedCellIndexPath.contains(indexPath){
                cell.commentLabel.numberOfLines = 0
            } else {
                cell.commentLabel.numberOfLines = 5
            }
            
            let comment = comments[comments.count - 2]
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
            
            //cell.isUserInteractionEnabled = false
            Storage.storage().reference(forURL: picURL).getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) in
                let image = UIImage(data: data!)
                cell.displayPicImageView.image = image
                
            })
            
            let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            cell.layer.borderColor = color.cgColor
            cell.layer.borderWidth = 0.2
            return cell
            
        } else if comments.count > 2 && indexPath.row == 11{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocCommentCell") as! LocCommentTableViewCell
            
            if selectedCellIndexPath.contains(indexPath){
                cell.commentLabel.numberOfLines = 0
            } else {
                cell.commentLabel.numberOfLines = 5
            }
            
            let comment = comments[comments.count - 3]
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
            
            //cell.isUserInteractionEnabled = false
            Storage.storage().reference(forURL: picURL).getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) in
                let image = UIImage(data: data!)
                cell.displayPicImageView.image = image
                
            })
            
            let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            cell.layer.borderColor = color.cgColor
            cell.layer.borderWidth = 0.2
            return cell
        } else if comments.count > 3 && indexPath.row == 12{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocCommentCell") as! LocCommentTableViewCell
            
            if selectedCellIndexPath.contains(indexPath){
                cell.commentLabel.numberOfLines = 0
            } else {
                cell.commentLabel.numberOfLines = 5
            }
            
            let comment = comments[comments.count - 4]
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
            
            //cell.isUserInteractionEnabled = false
            Storage.storage().reference(forURL: picURL).getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) in
                let image = UIImage(data: data!)
                cell.displayPicImageView.image = image
                
            })
            
            let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            cell.layer.borderColor = color.cgColor
            cell.layer.borderWidth = 0.2
            return cell
        } else if comments.count > 4 && indexPath.row == 13{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocCommentCell") as! LocCommentTableViewCell
            
            if selectedCellIndexPath.contains(indexPath){
                cell.commentLabel.numberOfLines = 0
            } else {
                cell.commentLabel.numberOfLines = 5
            }
            
            let comment = comments[comments.count - 5]
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
            
            //cell.isUserInteractionEnabled = false
            Storage.storage().reference(forURL: picURL).getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) in
                let image = UIImage(data: data!)
                cell.displayPicImageView.image = image
                
            })
            
            let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            cell.layer.borderColor = color.cgColor
            cell.layer.borderWidth = 0.2
            return cell
        } else if comments.count > 5 && indexPath.row == 14{
            let cell = UITableViewCell()
            cell.textLabel?.text = "VIEW ALL"
            cell.textLabel?.textColor = UIColor(red: 255.0/255.0, green: 146.0/255.0, blue: 0.0, alpha: 1.0)
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            cell.textLabel?.textAlignment = .center
            return cell
        }
        } else {
            if i == 0{
                let cell = UITableViewCell()
                cell.backgroundColor = UIColor(red: 255.0/255.0, green: 146.0/255.0, blue: 0.0, alpha: 1.0)
                cell.textLabel?.textColor = UIColor.black
                cell.textLabel?.numberOfLines = 2
                let newView = CosmosView(frame: CGRect(x: 20, y: 10, width: 150, height: 50))
                newView.updateOnTouch = false
                newView.filledColor = UIColor.red
                newView.starMargin = 0
                newView.fillMode = 2
                newView.emptyBorderColor = UIColor.clear
                newView.filledBorderColor = UIColor.clear
                newView.rating = (event.rating)
                let roundedRating = round(100.0 * (event.rating)) / 100.0
                newView.text = "  \(roundedRating)   Comments: \(comments.count) "
                newView.textColor = UIColor.black
                newView.emptyColor = UIColor.lightGray
                newView.starSize = 25
                newView.textSize = 14
                cell.contentView.addSubview(newView)
                return cell
            }else if i == 1{
                let cell = UITableViewCell()
                let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                cell.layer.borderColor = color.cgColor
                cell.layer.borderWidth = 0.2
                cell.textLabel?.text = event.description
                return cell
            } else if i == 2{
                let cell = UITableViewCell()
                let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                cell.layer.borderColor = color.cgColor
                cell.layer.borderWidth = 0.2
                cell.textLabel?.text = event.address.joined(separator: "\n")
                cell.imageView?.image = UIImage(named: "map")
                
                let itemSize = CGSize(width: 20, height: 20)
                UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
                let imageRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
                cell.imageView!.image?.draw(in: imageRect)
                cell.imageView!.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return cell
                
            } else if i == 3 {
                let cell = UITableViewCell()
                let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                cell.layer.borderColor = color.cgColor
                cell.layer.borderWidth = 0.2
                cell.textLabel?.text = event.websiteURL
                cell.imageView?.image = UIImage(named: "link")
                
                let itemSize = CGSize(width: 20, height: 20)
                UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
                let imageRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
                cell.imageView!.image?.draw(in: imageRect)
                cell.imageView!.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return cell
            } else if i == 4{
                let cell = UITableViewCell()
                let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                cell.layer.borderColor = color.cgColor
                cell.layer.borderWidth = 0.2
                var times = ""
                //for time in (event.times){
                   // times = times + "\n" + time
                //}
                if times == ""{
                    cell.textLabel?.text = "No info. Click here to add!"
                } else {
                    cell.textLabel?.text = times
                }
                cell.imageView?.image = UIImage(named: "hours")
                
                let itemSize = CGSize(width: 20, height: 20)
                UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
                let imageRect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
                cell.imageView!.image?.draw(in: imageRect)
                cell.imageView!.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return cell
            } else if i == 5{
                let cell = UITableViewCell()
                let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                cell.layer.borderColor = color.cgColor
                cell.layer.borderWidth = 0.2
                cell.textLabel?.numberOfLines = 0
                var castStr = ""
                for (group, cast) in event.cast{
                    var newGroup = group
                    if group.contains("(period)"){
                        newGroup = group.replacingOccurrences(of: "(period)", with: ".")
                    }
                    castStr = castStr + "\n" + newGroup + "\n\n"
                    for (actor, character) in cast{
                        castStr = castStr + "\(actor) as \(character)\n"
                    }
                }
                if castStr == ""{
                    cell.textLabel?.text = "Cast: No info. Click here to add!"
                } else {
                    cell.textLabel?.text = castStr
                }
                return cell
            } else if i == 6{
                let cell = UITableViewCell()
                let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                cell.layer.borderColor = color.cgColor
                cell.layer.borderWidth = 0.2
                var titles = ""
                for title in (event.relatedTitles){
                    titles = titles + ", " + title
                }
                if titles == ""{
                    cell.textLabel?.text = "Goods from: No info. Click here to add!"
                } else{
                    cell.textLabel?.text = "Goods from: \(titles)"
                }
                return cell
            } else if i == 7{
                let cell = UITableViewCell()
                let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                cell.layer.borderColor = color.cgColor
                cell.layer.borderWidth = 0.2
                cell.textLabel?.text = "Last updated: \(event.lastUpdated)"
                cell.textLabel?.textColor = UIColor.black
                cell.isUserInteractionEnabled = false
                return cell
            } else if i == 8{
                let cell = UITableViewCell()
                let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                cell.layer.borderColor = color.cgColor
                cell.layer.borderWidth = 0.2
                cell.backgroundColor = UIColor(red: 255.0/255.0, green: 146.0/255.0, blue: 0.0, alpha: 1.0)
                cell.textLabel?.textColor = UIColor.black
                let newView = CosmosView(frame: CGRect(x: cell.center.x - 43.75, y: 5, width: 150, height: 45))
                if let index = event.ratedUsers.index(of: (Auth.auth().currentUser?.uid)!){
                    newView.updateOnTouch = false
                    newView.rating = (event.ratings[index])
                    cell.isUserInteractionEnabled = false
                } else {
                    newView.updateOnTouch = true
                    newView.rating = 0
                }
                
                newView.filledColor = UIColor.red
                newView.starMargin = 0
                newView.fillMode = 0
                newView.emptyBorderColor = UIColor.clear
                newView.filledBorderColor = UIColor.clear
                newView.emptyColor = UIColor.lightGray
                newView.starSize = 35
                cell.contentView.addSubview(newView)
                cosmosView = newView
                return cell
            } else if (comments.count == 0 && indexPath.row == 9){
                let cell = UITableViewCell()
                cell.textLabel?.text = "No comments have been left so far. Be the first and leave one now!"
                return cell
            } else if (comments.count == 0 && indexPath.row == 10) || (comments.count == 1 && indexPath.row == 10) || (comments.count == 2 && indexPath.row == 11) || (comments.count == 3 && indexPath.row == 12) || (comments.count == 4 && indexPath.row == 13) || (comments.count == 5 && indexPath.row == 14) ||
                (comments.count > 5 && indexPath.row == 15){
                let cell = UITableViewCell()
                cell.textLabel?.text = "Leave a comment!"
                cell.backgroundColor = UIColor(red: 255.0/255.0, green: 146.0/255.0, blue: 0.0, alpha: 1.0)
                cell.textLabel?.textColor = UIColor.black
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
                return cell
            } else if comments.count > 0 && indexPath.row == 9{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "LocCommentCell") as! LocCommentTableViewCell
                
                if selectedCellIndexPath.contains(indexPath){
                    cell.commentLabel.numberOfLines = 0
                } else {
                    cell.commentLabel.numberOfLines = 5
                }
                
                let comment = comments[comments.count - 1]
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
                
                //cell.isUserInteractionEnabled = false
                Storage.storage().reference(forURL: picURL).getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) in
                    let image = UIImage(data: data!)
                    cell.displayPicImageView.image = image
                    
                })
                
                let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                cell.layer.borderColor = color.cgColor
                cell.layer.borderWidth = 0.2
                return cell
            } else if comments.count > 1 && indexPath.row == 10{
                let cell = tableView.dequeueReusableCell(withIdentifier: "LocCommentCell") as! LocCommentTableViewCell
                
                if selectedCellIndexPath.contains(indexPath){
                    cell.commentLabel.numberOfLines = 0
                } else {
                    cell.commentLabel.numberOfLines = 5
                }
                
                let comment = comments[comments.count - 2]
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
                
                //cell.isUserInteractionEnabled = false
                Storage.storage().reference(forURL: picURL).getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) in
                    let image = UIImage(data: data!)
                    cell.displayPicImageView.image = image
                    
                })
                
                let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                cell.layer.borderColor = color.cgColor
                cell.layer.borderWidth = 0.2
                return cell
                
            } else if comments.count > 2 && indexPath.row == 11{
                let cell = tableView.dequeueReusableCell(withIdentifier: "LocCommentCell") as! LocCommentTableViewCell
                
                if selectedCellIndexPath.contains(indexPath){
                    cell.commentLabel.numberOfLines = 0
                } else {
                    cell.commentLabel.numberOfLines = 5
                }
                
                let comment = comments[comments.count - 3]
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
                
                //cell.isUserInteractionEnabled = false
                Storage.storage().reference(forURL: picURL).getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) in
                    let image = UIImage(data: data!)
                    cell.displayPicImageView.image = image
                    
                })
                
                let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                cell.layer.borderColor = color.cgColor
                cell.layer.borderWidth = 0.2
                return cell
            } else if comments.count > 3 && indexPath.row == 12{
                let cell = tableView.dequeueReusableCell(withIdentifier: "LocCommentCell") as! LocCommentTableViewCell
                
                if selectedCellIndexPath.contains(indexPath){
                    cell.commentLabel.numberOfLines = 0
                } else {
                    cell.commentLabel.numberOfLines = 5
                }
                
                let comment = comments[comments.count - 4]
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
                
                //cell.isUserInteractionEnabled = false
                Storage.storage().reference(forURL: picURL).getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) in
                    let image = UIImage(data: data!)
                    cell.displayPicImageView.image = image
                    
                })
                
                let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                cell.layer.borderColor = color.cgColor
                cell.layer.borderWidth = 0.2
                return cell
            } else if comments.count > 4 && indexPath.row == 13{
                let cell = tableView.dequeueReusableCell(withIdentifier: "LocCommentCell") as! LocCommentTableViewCell
                
                if selectedCellIndexPath.contains(indexPath){
                    cell.commentLabel.numberOfLines = 0
                } else {
                    cell.commentLabel.numberOfLines = 5
                }
                
                let comment = comments[comments.count - 5]
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
                
                //cell.isUserInteractionEnabled = false
                Storage.storage().reference(forURL: picURL).getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) in
                    let image = UIImage(data: data!)
                    cell.displayPicImageView.image = image
                    
                })
                
                let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
                cell.layer.borderColor = color.cgColor
                cell.layer.borderWidth = 0.2
                return cell
            } else if comments.count > 5 && indexPath.row == 14{
                let cell = UITableViewCell()
                cell.textLabel?.text = "VIEW ALL"
                cell.textLabel?.textColor = UIColor(red: 255.0/255.0, green: 146.0/255.0, blue: 0.0, alpha: 1.0)
                cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
                cell.textLabel?.textAlignment = .center
                return cell
            }
        }
        return UITableViewCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "writeCommentSegue"{
            
            let nextVC = segue.destination as! WriteCommentViewController
            nextVC.locID = (loc.locID)
            nextVC.eventID = event.eventID
            if rating == true{
                nextVC.rating = cosmosView.rating
            }
        } else if segue.identifier == "viewAllSegue"{
            let nextVC = segue.destination as! CommentsTableViewController
            nextVC.comments = comments
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = UIColor(red: 255.0/255.0, green: 146.0/255.0, blue: 0.0, alpha: 1.0)
        header.textLabel?.numberOfLines = 0
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont(name: (header.textLabel?.font.fontName)!, size: 18)
        
        
    }
    
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            // not a valid URL
            return
        }
        
        if ["http", "https"].contains(url.scheme?.lowercased() ?? "") {
            // Can open with SFSafariViewController
            let safariViewController = SFSafariViewController(url: url)
            self.present(safariViewController, animated: true, completion: nil)
        } else {
            // Scheme is not supported or no scheme is given, use openURL
            let url = URL(string: "https://www.google.com/search?q=\(urlString)")
            
            let safariViewController = SFSafariViewController(url: url!)
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
    
}
