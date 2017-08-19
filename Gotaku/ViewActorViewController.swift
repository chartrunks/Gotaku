//
//  ViewActorViewController.swift
//  Gotaku
//
//  Created by Mac on 6/15/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import SafariServices
import MapKit

class DetailTableViewCell: UITableViewCell{
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var detailInfoLabel: UILabel!
}

class HorizontalPictureTableViewCell: UITableViewCell{
    
    @IBOutlet weak var actorImageView: UIImageView!
}

class ViewActorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var actor = Actor()
    
    var actorInfo : [String:Any] = [:]
    
    var roles : [Event] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = actor.englishName
        tableView.delegate = self
        tableView.dataSource = self
        for roleID in actor.roles{
            Database.database().reference().child("eventInfo").child("events").child(roleID).observeSingleEvent(of: .value, with: { (snapshot) in
                let event = Event()
                //All locations must have the following
                let title = (snapshot.value as! NSDictionary)["name"] as! String
                let category = (snapshot.value as! NSDictionary)["category"] as! String
                event.name = title
                event.eventID = roleID
                
                event.rating = (snapshot.value as! NSDictionary)["rank"]
                    as! Double
                event.lastUpdated = (snapshot.value as! NSDictionary)["lastUpdated"] as! String
                event.views = (snapshot.value as! NSDictionary)["views"] as! Int
                event.category = category
                event.active = (snapshot.value as! NSDictionary)["active"] as! Int
                
                //Optional values
                if snapshot.hasChild("address"){
                    event.address = ((snapshot.value as! NSDictionary)["address"] as! String).components(separatedBy: " ")
                }
                if snapshot.hasChild("description"){
                    event.description = (snapshot.value as! NSDictionary)["description"] as! String
                }
                if snapshot.hasChild("website"){
                    event.websiteURL = (snapshot.value as! NSDictionary)["website"] as! String
                }
                if snapshot.hasChild("goodsURL"){
                    event.goodsURL = (snapshot.value as! NSDictionary)["goodsURL"] as! String
                }
                if snapshot.hasChild("goodsDescrip"){
                    event.goodsDescrip = (snapshot.value as! NSDictionary)["goodsDescrip"] as! String
                }
                
                //Optional values that should be turned into a String Array
                if snapshot.hasChild("pictureURLS"){
                    event.pictureURLs = ((snapshot.value as! NSDictionary)["pictureURLs"] as! String).components(separatedBy: " ")
                }
                if snapshot.hasChild("times"){
                    var timeDicArray : [String: [String]] = [:]
                    let timeDic = (snapshot.value as! NSDictionary)["times"] as! [String:String]
                    for (loc, times) in timeDic{
                        if times.contains("-"){
                            timeDicArray[loc] = times.components(separatedBy: " - ")
                        } else {
                        timeDicArray[loc] = times.components(separatedBy: "~")
                        }
                    }
                    event.times = timeDicArray
                }
                
                if snapshot.hasChild("ratings"){
                    let strArray : [String] = ((snapshot.value as! NSDictionary)["ratings"] as! String).components(separatedBy: " ")
                    
                    event.ratings = strArray.map{ Double($0)!}
                }
                if snapshot.hasChild("ratedUsers"){
                    event.ratedUsers = ((snapshot.value as! NSDictionary)["ratedUsers"] as! String).components(separatedBy: " ")
                }
                if snapshot.hasChild("cast"){
                    event.cast = (snapshot.value as! NSDictionary)["cast"] as! [String: [String:String]]
                }
                
                if snapshot.hasChild("coordLat"){
                    var coords : [CLLocationCoordinate2D] = []
                    var coordLats : [Double] = []
                    var coordLons : [Double] = []
                    let coordLatsStr : [String] = ((snapshot.value as! NSDictionary)["coordLat"] as! String).components(separatedBy: " ")
                    let coordLonsStr : [String] = ((snapshot.value as! NSDictionary)["coordLon"] as! String).components(separatedBy: " ")
                    
                    for str in coordLatsStr{
                        coordLats.append(Double(str)!)
                    }
                    
                    for str in coordLonsStr{
                        coordLons.append(Double(str)!)
                        
                    }
                    var index = 0
                    while index < coordLats.count{
                        let coord = CLLocationCoordinate2D(latitude: coordLats[index], longitude: coordLons[index])
                        coords.append(coord)
                        index += 1
                    }
                    event.coordinates = coords
                }
                self.roles.append(event)
                
            })
            
        }
        actorInfo["actorID"] = actor.actorID
        actorInfo["englishName"] = actor.englishName
        actorInfo["japaneseName"] = actor.japaneseName
        if actor.agency != ""{
            actorInfo["agency"] = actor.agency
        }
        if actor.agencyURL != ""{
            actorInfo["agencyURL"] = actor.agencyURL
        }
        if actor.blogURL != ""{
            actorInfo["blogURL"] = actor.blogURL
        }
        if actor.twitterURL != ""{
            actorInfo["twitterURL"] = actor.twitterURL
        }
        if actor.bloodtype != ""{
            actorInfo["bloodType"] = actor.bloodtype
        }
        if actor.description != ""{
            actorInfo["description"] = actor.description
        }
        if actor.birthdate != ""{
            actorInfo["birthdate"] = actor.birthdate
        }
        if actor.age != 0{
            actorInfo["age"] = actor.age
        }
        if actor.lastUpdated != ""{
            actorInfo["lastUpdated"] = actor.lastUpdated
        }
        if actor.height != 0{
            actorInfo["height"] = actor.height
        }
        if actor.roles != []{
            actorInfo["roles"] = actor.roles.joined(separator: " ")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let i = indexPath.row
        if i == 0{
            if actor.picURLs.count > 0{
            let picURL = actor.picURLs[0]
                //let dimensions : [String] = actor.picDimensions[0].components(separatedBy: "/")
                //let width = dimensions[0]
                //let height = dimensions[1]
            
                let cell = tableView.dequeueReusableCell(withIdentifier: "horPicCell") as! HorizontalPictureTableViewCell
                
                //if height > width{
//                   cell.actorImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//                    cell.actorImageView.contentMode = .scaleAspectFill
                    //cell.actorImageView.frame = CGRect(x: 0, y: 0, width: 239.0, height: 335.0)
               // }
            Storage.storage().reference(forURL: picURL).getData(maxSize: 25 * 1024 * 1024, completion: { (data, error) in
                let image = UIImage(data: data!)!

//                let size = image.size
//                
//                let widthRatio  = 239.0  / image.size.width
//                let heightRatio = 335.0 / image.size.height
//                
//                // Figure out what our orientation is, and use that to form the rectangle
//                var newSize: CGSize
//                if(widthRatio > heightRatio) {
//                    newSize = CGSize(width:size.width * heightRatio, height:size.height * heightRatio)
//                } else {
//                    newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
//                }
//                
//                // This is the rect that we've calculated out and this is what is actually used below
//                let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
//                
//                // Actually do the resizing to the rect using the ImageContext stuff
//                UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
//                image.draw(in: rect)
//                let newImage = UIGraphicsGetImageFromCurrentImageContext()
//                UIGraphicsEndImageContext()
                
                cell.actorImageView.image = image
            })
                cell.isUserInteractionEnabled = false
                return cell
            
            
            } else {
                return UITableViewCell()
            }
        } else if i == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailTableViewCell
            cell.detailLabel.text = "Name:"
            cell.detailInfoLabel.text = "\(actor.englishName) (\(actor.japaneseName))"
            return cell
        } else if i == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailTableViewCell
            cell.detailLabel.text = "Birthdate:"
            if actor.birthdate == ""{
                cell.detailInfoLabel.text = "No info. Swipe to edit!"
            } else {
            cell.detailInfoLabel.text = "\(actor.birthdate) (\(actor.age))"
            }
            return cell
        } else if i == 6{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailTableViewCell
            cell.detailLabel.text = "Agency:"
            if actor.agency == ""{
                cell.detailInfoLabel.text = "No info. Swipe to edit!"
            } else {
            cell.detailInfoLabel.text = actor.agency
            }
            return cell
        } else if i == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailTableViewCell
            cell.detailLabel.text = "Height:"
            if actor.height == 0{
                cell.detailInfoLabel.text = "No info. Swipe to edit!"
            } else {
            cell.detailInfoLabel.text = "\(actor.height) cm"
            }
            return cell
        } else if i == 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailTableViewCell
            cell.detailLabel.text = "Blood Type:"
            if actor.bloodtype == ""{
                cell.detailInfoLabel.text = "No info. Swipe to edit!"
            } else {
            cell.detailInfoLabel.text = actor.bloodtype
            }
            return cell
        } else if i == 7{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailTableViewCell
            cell.detailLabel.text = "Twitter:"
            if actor.twitterURL == ""{
                cell.detailInfoLabel.text = "No info. Swipe to edit!"
            } else {
            cell.detailInfoLabel.text = actor.twitterURL
            }
            return cell
        } else if i == 8{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! DetailTableViewCell
            cell.detailLabel.text = "Blog:"
            if actor.blogURL == ""{
                cell.detailInfoLabel.text = "No info. Swipe to edit!"
            } else {
            cell.detailInfoLabel.text = actor.blogURL
            }
            return cell
        } else if i == 1{
            let cell = UITableViewCell()
            if actor.description == ""{
                cell.textLabel?.text = "No info. Swipe to edit!"
            } else {
            cell.textLabel?.text = actor.description
            }
            return cell
        } else if i == 9{
            let cell = UITableViewCell()
            cell.textLabel?.numberOfLines = 0
            let last = roles.count - 1
            var index = 0
            var rolesStr = ""
            for role in roles{
                var roleStr = "• "
                roleStr.append("\(role.name) (")
                var timeArr : [String] = []
                for (loc, times) in role.times{
                    for time in role.times[loc]!{
                        timeArr.append(time)
                    }
                }
                let arrayCount = timeArr.count
                var timeDateArr : [Date] = []
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateStyle = .short
                if timeArr[0].contains(":"){
                dateFormatter.timeStyle = .short
                }
                for time in timeArr{
                    timeDateArr.append(dateFormatter.date(from: time)!)
                }
                timeDateArr = timeDateArr.sorted(by: { $0.timeIntervalSince1970 < $1.timeIntervalSince1970})
                var i = 0
                for date in timeDateArr{
                    timeArr[i] = dateFormatter.string(from: date)
                    i += 1
                }
                if arrayCount == 1{
                    roleStr.append(timeArr[0].components(separatedBy: ", ")[0])
                } else if arrayCount > 1{
                    let start = timeArr[0].components(separatedBy: ", ")[0]
                    let end = timeArr[timeArr.count - 1].components(separatedBy: ", ")[0]
                    if start != end{
                    roleStr.append("\(start) - \(end)")
                    } else {
                        roleStr.append("\(start)")
                    }
                }
                var found = false
                for (_, cast) in role.cast{
                    for (castActor, role) in cast{
                        if castActor == actor.actorID{
                            roleStr.append(") - \(role)")
                            found = true
                        }
                    }
                }
                if found == false{
                    actor.roles = actor.roles.filter {$0 != role.eventID}
            Database.database().reference().child("actorInfo").child("actors").child(actor.actorID).child("roles").setValue(actor.roles.joined(separator: " "))
                }
                
                if index != last{
                    roleStr.append("\n\n")
                }
                rolesStr.append(roleStr)
                index += 1
            }
            if rolesStr == ""{
                cell.textLabel?.text = "No roles added. Click to add!"
            } else{
            cell.textLabel?.text = rolesStr
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let i = indexPath.row
        if i == 6{
            openURL(actor.agencyURL)
        } else if i == 7{
            openURL(actor.twitterURL)
        } else if i == 8{
            openURL(actor.blogURL)
        } else if i == 9{
            performSegue(withIdentifier: "viewRoleInfoSegue", sender: nil)
        }
        
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
    
    @IBAction func editTapped(_ sender: Any) {
        performSegue(withIdentifier: "editActorSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editActorSegue"{
        let nextVC = segue.destination as! AddActorNameViewController
        nextVC.actor = actor
        } else if segue.identifier == "editNameSegue"{
            let nextVC = segue.destination as! AddActorNameViewController
            nextVC.edit = true
            nextVC.actor = actor
            nextVC.actorInfo = actorInfo
            nextVC.callback = { selection in
                self.actorInfo = selection
                self.actor.englishName = selection["englishName"] as! String
                self.actor.japaneseName = selection["japaneseName"] as! String
                self.actor.actorID = selection["actorID"] as! String
                self.tableView.reloadData()
            }
        } else if segue.identifier == "editBDaySegue"{
            let nextVC = segue.destination as! AddActorBdayViewController
            nextVC.edit = true
            nextVC.actor = actor
            nextVC.actorInfo = actorInfo
            nextVC.callback = { selection in
                self.actorInfo = selection
                self.actor.birthdate = selection["birthdate"] as! String
                self.actor.age = selection["age"] as! Int
                self.tableView.reloadData()
            }
        } else if segue.identifier == "editHeightBloodTypeSegue"{
            let nextVC = segue.destination as! AddActorHeightBloodTypeViewController
            nextVC.edit = true
            nextVC.actor = actor
            nextVC.actorInfo = actorInfo
            nextVC.callback = { selection in
                self.actorInfo = selection
                self.actor.height = selection["height"] as! Int
                self.actor.bloodtype = selection["bloodType"] as! String
                self.tableView.reloadData()
            }
        } else if segue.identifier == "editSocialMediaSegue"{
            let nextVC = segue.destination as! AddActorSocialMediaViewController
            nextVC.edit = true
            nextVC.actor = actor
            nextVC.actorInfo = actorInfo
            nextVC.callback = { selection in
                self.actorInfo = selection
                self.actor.agency = selection["agency"] as! String
                self.actor.agencyURL = selection["agencyURL"] as! String
                self.actor.blogURL = selection["blogURL"] as! String
                self.actor.twitterURL = selection["twitterURL"] as! String
                self.tableView.reloadData()
            }
        } else if segue.identifier == "editDescriptionSegue"{
            let nextVC = segue.destination as! AddActorDescriptionViewController
            nextVC.actor = actor
            nextVC.actorInfo = actorInfo
            nextVC.callback = { selection in
                self.actorInfo = selection
                self.actor.description = selection["description"] as! String
                self.tableView.reloadData()
            }
        } else if segue.identifier == "addRoleSegue"{
         let nextVC = segue.destination as! AddLocationTypeViewController
        } else if segue.identifier == "viewRoleInfoSegue"{
            let nextVC = segue.destination as! ViewRoleInfoViewController
            nextVC.roles = roles
            nextVC.actorID = actor.actorID
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 375.0
        }
        tableView.estimatedRowHeight = 150.0
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let i = indexPath.row
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            if i == 1{
                self.performSegue(withIdentifier: "editDescriptionSegue", sender: nil)
            } else if i == 2{
                self.performSegue(withIdentifier: "editNameSegue", sender: nil)
            } else if i == 3{
                self.performSegue(withIdentifier: "editBDaySegue", sender: nil)
            } else if i == 4 || i == 5{
                self.performSegue(withIdentifier: "editHeightBloodTypeSegue", sender: nil)
            } else if i == 6 || i == 7 || i == 8{
                self.performSegue(withIdentifier: "editSocialMediaSegue", sender: nil)
            } else if i == 9{
                self.performSegue(withIdentifier: "addRoleSegue", sender: nil)
            }
            
        }
        
        if i == 9{
            editAction.title = "Add"
        }
        editAction.backgroundColor = UIColor.orange
        
        return [editAction]
    }
}
