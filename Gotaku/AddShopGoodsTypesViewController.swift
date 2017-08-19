//
//  AddShopGoodsTypesViewController.swift
//  Gotaku
//
//  Created by Mac on 6/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class AddShopGoodsTypesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nextSkipButton: UIBarButtonItem!
    
    var initialVC = ""
    
    var tableData : [String] = []
    
    var goodsTypes : [String] = []
    
    var shop : Location = Location()
    
    var locationInfo : [String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(true, animated: false)
        
            tableData = ["Body Pillows", "Bromides", "CDs - Anime", "CDs - 2.5D", "CDs - Video Games", "Doujinshi", "DVDs - Anime", "DVDs - 2.5D", "Figures", "Folders", "Key Chains", "Manga", "Pins", "Plushes", "Posters", "Trading Cards", "Video Games"]
        goodsTypes = shop.goodsTypes
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if goodsTypes.contains(tableData[indexPath.row]){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        cell.textLabel?.text = tableData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        goodsTypes.append(tableData[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = UITableViewCellAccessoryType.none
        goodsTypes = goodsTypes.filter {$0 != tableData[indexPath.row]}
    }

    @IBAction func nextTapped(_ sender: Any) {
        locationInfo["goodsTypes"] = goodsTypes.joined(separator: ",")
        performSegue(withIdentifier: "addRelatedTitlesSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let nextVC = segue.destination as! AddShopRelatedTitlesViewController
        nextVC.locationInfo = locationInfo
        nextVC.initialVC = initialVC
    }
    
}
