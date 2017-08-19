//
//  MainMenuViewController.swift
//  Gotaku
//
//  Created by Mac on 6/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var menuImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
}

class MainMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let menuOptions = ["Map", "Shops", "Events", "2.5D Shows", "Food/Drink", "Attractions", "Actors"]
    let descriptions = ["View locations in your area.", "Browse shops by region or search for a shop.", "Find something to do next weekend!", "Check out past, present, and future 2.5D shows!", "Find a geeky spot to eat or grab a drink.", "Look for something to do during your next vacation.", "Check out what your favorite actors are up to."]
    let images = ["mapMenu", "shopMenu", "eventMenu", "twoPointFiveMenu", "foodMenu", "attractionMenu", "actorMenu"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let i = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuCell
        if i == 0{
            cell.backgroundColor = UIColor.red
        } else if i == 1{
            cell.backgroundColor = UIColor.blue
        } else if i == 2{
            cell.backgroundColor = UIColor.orange
        } else if i == 3{
            cell.backgroundColor = UIColor(colorLiteralRed: 0.0/255.0, green: 210.0/255.0, blue: 35.0/255.0, alpha: 1.0)
        } else if i == 4{
            cell.backgroundColor = UIColor(colorLiteralRed: 255.0/255.0, green: 200.0/255.0, blue: 0.0, alpha: 1.0)
        } else if i == 5{
            cell.backgroundColor = UIColor(colorLiteralRed: 252.0/255.0, green: 0.0, blue: 135.0/255.0, alpha: 1.0)
        } else if i == 6{
            cell.backgroundColor = UIColor(colorLiteralRed: 213.0/255.0, green: 0.0, blue: 232.0/255.0, alpha: 1.0)
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.titleLabel?.text = menuOptions[indexPath.row]
        cell.descriptionLabel?.text = descriptions[indexPath.row]
        cell.menuImageView.image = UIImage(named: images[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let i = indexPath.row
        if i == 0{
                performSegue(withIdentifier: "viewMapSegue", sender: nil)
        } else if i == 1 || i == 4 || i == 5{
            performSegue(withIdentifier: "viewAllLocationsSegue", sender: i)
        } else if i == 2 || i == 3{
            performSegue(withIdentifier: "viewAllEventsSegue", sender: i)
        } else if i == 6{
            performSegue(withIdentifier: "viewAllActorsSegue", sender: nil)
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewAllLocationsSegue"{
            let i = sender as! Int
            let nextVC = segue.destination as! ViewAllShopsFoodViewController
            if i == 1{
                nextVC.locationType = "shop"
            } else if i == 4{
                nextVC.locationType = "food"
            } else{
                nextVC.locationType = "attraction"
            }
            
        } else if segue.identifier == "viewAllEventsSegue"{
            let i = sender as! Int
            let nextVC = segue.destination as! ViewAllEventsShowsViewController
            if i == 2{
                nextVC.eventType = "event"
            } else if i == 3{
                nextVC.eventType = "twoPointFive"
            }
        }
    }
}
