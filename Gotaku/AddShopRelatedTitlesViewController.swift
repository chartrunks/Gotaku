//
//  AddShopRelatedTitlesViewController.swift
//  Gotaku
//
//  Created by Mac on 6/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddShopRelatedTitlesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nextSkipButton: UIBarButtonItem!
    
    var initialVC = ""
    
    var tableData : [String] = []
    
    var relatedTitles : [String] = []
    
    var locationInfo : [String:Any] = [:]
    
    var shop : Location = Location()
    
    var enteredShops : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: false)
        
        
            tableData = ["Ai-Chuu", "Akira", "All Out!", "Amnesia", "Angel Beats!", "Animal Crossing", "Assassination Classroom", "Attack on Titan", "Azumanga Daioh", "B-Project", "Bakuman", "Berserk", "Binan Koukou Chikyuu Bouei-bu LOVE!", "Bleach", "Blue Exorcist", "Boku no Hero Academia", "Brothers Conflict", "Bungou Stray Dogs", "Cardcaptor Sakura", "Captain Tsubasa", "Clannad", "Code Geass", "Cowboy Bebop", "Crayon Shin-chan", "D.Gray-man", "Dance with Devils", "Danganronpa", "Darker than Black", "Death Note", "Detective Conan", "Diabolik Lovers", "Diamond no Ace", "Digimon", "Dragon Ball", "Dragon Ball Z", "Dragon Ball Super", "Dragon Quest", "Durarara!!", "Ensemble Stars!", "Eureka Seven", "Fairy Tail", "Fate/stay night", "Fate/Zero", "Final Fantasy", "Free!", "Fruits Basket", "Fushigi Yuugi", "Gantz", "Gatchaman", "Gin no Saji", "Gintama", "Ghost in the Shell", "Gundam", "Haikyuu!!", "Hakuouki", "Hellsing", "Hetalia", "Highschool of the Dead", "Hunter x Hunter", "The iDOLM@STER", "InuYasha", "JoJo's Bizarre Adventure", "K", "K-On!", "Kantai Collection", "Kamen Rider", "Kill la Kill", "Kimi no Na wa", "Kingdom Hearts", "Kirby", "Kuroko no Basuke", "Kuroshitsuji", "The Legend of Zelda", "Love Live!", "Lupin III", "Macross", "Magi: The Labyrinth of Magic", "Mahou Shoujo Madoka Magica", "Makai Ouji", "Super Mario Bros.", "Mawaru Penguindrum", "Mega Man", "The Melancholy of Haruhi Suzumiya", "Metal Gear Solid", "Mirai Nikki", "Monogatari series", "Monster Hunter", "Mushishi", "Naruto", "Natsume's Book of Friends", "Neon Genesis Evangelion", "No. 6", "Noragami", "One Piece", "One Punch Man", "Osomatsu-san", "Ouran High School Host Club", "Persona", "Pokemon", "Prince of Stride", "Prince of Tennis", "Psycho-Pass", "Re:Zero", "Resident Evil", "Rurouni Kenshin", "Sailor Moon", "Sakamoto desu ga?", "Samurai Champloo", "Sengoku Basara", "Seraph of the End", "Shirokuma Cafe", "Show By Rock!!", "Sonic the Hedgehog", "Soul Eater", "Starmyu", "Steins;Gate", "Studio Ghibli", "Sword Art Online", "Tales of Series", "Tengen Toppa Gurren Lagann", "Terra Formars", "Tiger & Bunny", "Tokyo Ghoul", "Toradora", "Toriko", "Touken Ranbu", "Trigun", "Tsubasa", "Tsukiuta", "Uta no Prince-sama", "VOCALOID", "Wolf's Rain", "Working!!", "xxxHOLiC", "Yokai Watch", "Yowamushi Pedal", "Yu-Gi-Oh!", "Yuri!! on ICE", "Yuu Yuu Hakusho"]
        
        relatedTitles = shop.relatedTitles
        
        Database.database().reference().child("locationInfo").observeSingleEvent(of: .value) { (snapshot) in
            self.enteredShops = ((snapshot.value as! NSDictionary)["enteredShops"] as! String).components(separatedBy: "%")
        }
        enteredShops.append(locationInfo["name"] as! String)
        
      
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if relatedTitles.contains(tableData[indexPath.row]){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        cell.textLabel?.text = tableData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        relatedTitles.append(tableData[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = UITableViewCellAccessoryType.none
        relatedTitles = relatedTitles.filter {$0 != tableData[indexPath.row]}
    }
    
    @IBAction func nextTapped(_ sender: Any) {
        locationInfo["relatedTitles"] = relatedTitles.joined(separator: ",")
        locationInfo["rank"] = 0
        locationInfo["views"] = 0
        locationInfo["locID"] = NSUUID().uuidString
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        locationInfo["lastUpdated"] = formatter.string(from: currentDateTime)
        Database.database().reference().child("locationInfo").child("locations").child(locationInfo["locID"] as! String).setValue(locationInfo)
        Database.database().reference().child("locationInfo").child("enteredShops").setValue(enteredShops.joined(separator: "%"))
        if initialVC == "map"{
            self.popBack(toControllerType: MapViewController.self)
        }
    }
    
    /// pop back to specific viewcontroller
    func popBack<T: UIViewController>(toControllerType: T.Type) {
        if var viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            viewControllers = viewControllers.reversed()
            for currentViewController in viewControllers {
                if currentViewController .isKind(of: toControllerType) {
                    self.navigationController?.popToViewController(currentViewController, animated: true)
                    break
                }
            }
        }
    }
}
