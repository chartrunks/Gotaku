//
//  ViewAllActorsViewController.swift
//  Gotaku
//
//  Created by Mac on 6/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewAllActorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var actors : [Actor] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        Database.database().reference().child("actorInfo").child("actors").observe(.childAdded, with: { (snapshot) in
            let actor = Actor()
            actor.englishName = (snapshot.value as! NSDictionary)["englishName"] as! String!
            actor.japaneseName = (snapshot.value as! NSDictionary)["japaneseName"] as! String
            actor.actorID = (snapshot.value as! NSDictionary)["actorID"] as! String
            if snapshot.hasChild("birthdate"){
                actor.birthdate = (snapshot.value as! NSDictionary)["birthdate"] as! String
            }
            if snapshot.hasChild("age"){
            actor.age = (snapshot.value as! NSDictionary)["age"] as! Int
            }
            if snapshot.hasChild("height"){
            actor.height = (snapshot.value as! NSDictionary)["height"] as! Int
            }
            if snapshot.hasChild("bloodType"){
            actor.bloodtype = (snapshot.value as! NSDictionary)["bloodType"] as! String
            }
            if snapshot.hasChild("agency"){
            actor.agency = (snapshot.value as! NSDictionary)["agency"] as! String
            }
            if snapshot.hasChild("agencyURL"){
                 actor.agencyURL = (snapshot.value as! NSDictionary)["agencyURL"] as! String
            }
            if snapshot.hasChild("twitterURL"){
            actor.twitterURL = (snapshot.value as! NSDictionary)["twitterURL"] as! String
            }
            if snapshot.hasChild("blogURL"){
            actor.blogURL = (snapshot.value as! NSDictionary)["blogURL"] as! String
            }
            if snapshot.hasChild("description"){
            actor.description = (snapshot.value as! NSDictionary)["description"] as! String
            }
            if snapshot.hasChild("picURLs"){
            actor.picURLs = ((snapshot.value as! NSDictionary)["picURLs"] as! String).components(separatedBy: " ")
            }
            if snapshot.hasChild("picDimensions"){
                actor.picDimensions = ((snapshot.value as! NSDictionary)["picDimensions"] as! String).components(separatedBy: " ")
            }
            if snapshot.hasChild("roles"){
            actor.roles = ((snapshot.value as! NSDictionary)["roles"] as! String).components(separatedBy: " ")
                var index = 0
                var delIndex = 1000000
                for role in actor.roles{
                    if (actor.roles.filter{$0 == role}).count > 1{
                        delIndex = index
                    }
                    index += 1
                }
                if delIndex != 1000000{
                    
                    actor.roles.remove(at: delIndex)
                    
                    Database.database().reference().child("actorInfo").child("actors").child(actor.actorID).child("roles").setValue(actor.roles.joined(separator: " "))
                }
            }
            self.actors.append(actor)
            self.actors = self.actors.sorted { $0.englishName < $1.englishName }
            self.tableView.reloadData()
        })
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewActorSegue", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewActorSegue"{
        let nextVC = segue.destination as! ViewActorViewController
        nextVC.actor = actors[sender as! Int]
        }
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(actors[indexPath.row].englishName) (\(actors[indexPath.row].japaneseName))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actors.count
    }

}
