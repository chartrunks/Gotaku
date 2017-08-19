//
//  SearchTable.swift
//  Gotaku
//
//  Created by Mac on 7/4/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class SearchTable: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    var searchArray : [String] = []
    var searchActive : Bool = false
    
    let searchBar = UISearchBar()
    
    var callback : ((String) -> Void)?
    
    @IBOutlet weak var tableView: UITableView!
    
    var filtered:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchArray = searchArray.sorted { $0 < $1 }
        navigationItem.hidesBackButton = true
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == ""{
            searchActive = false
        } else {
        searchActive = true;
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    @IBAction func enterTapped(_ sender: Any) {
        if !searchArray.contains(searchBar.text!){
            //Keys must be non-empty and cannot contain '/' '.' '#' '$' '[' or ']''
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789()!:?-_<>,+=*&^%@~ ")
            if searchBar.text == ""{
                let alertVC = UIAlertController(title: "No Text Entered", message: "No name was entered. Please enter a name and then tap Enter.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertVC.addAction(OKAction)
                self.present(alertVC, animated: true, completion: nil)
            } else if searchBar.text?.rangeOfCharacter(from: characterset.inverted) != nil {
                
                if (searchBar.text?.contains("/"))! ||  (searchBar.text?.contains("#"))! || (searchBar.text?.contains("$"))! || (searchBar.text?.contains("["))! || (searchBar.text?.contains("]"))!{
                let alertVC = UIAlertController(title: "Invalid Character Entered", message: "The name you entered contains an invalid character. Please enter the name using only letters and numbers.", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertVC.addAction(OKAction)
                self.present(alertVC, animated: true, completion: nil)
                } else if (searchBar.text?.contains("."))!{
                    let newStr = searchBar.text?.replacingOccurrences(of: ".", with: "(period)")
                    callback?(newStr!)
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
        callback?(searchBar.text!)
        self.navigationController?.popViewController(animated: true)
            }
        } else {
            let alertVC = UIAlertController(title: "Group Exists", message: "A group with the name you've entered already exists. Either select the group or enter another name to create a new group.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertVC.addAction(OKAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = searchArray.filter({ (text) -> Bool in
            let tmp: NSString = text as! NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(searchText.characters.count == 0){
            searchActive = false
        } else {
            searchActive = true
        }
        self.tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(searchActive){
            if filtered.count != 0{
            callback?(filtered[indexPath.row])
            }
        } else {
           callback?(searchArray[indexPath.row])
        }
        
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if(searchActive){
            if filtered[indexPath.row].contains("(period)"){
                cell.textLabel?.text = filtered[indexPath.row].replacingOccurrences(of: "(period)", with: ".")
            } else{
            cell.textLabel?.text = filtered[indexPath.row]
            }
        } else {
            if searchArray[indexPath.row].contains("(period)"){
                cell.textLabel?.text = searchArray[indexPath.row].replacingOccurrences(of: "(period)", with: ".")
            } else{
            cell.textLabel?.text = searchArray[indexPath.row]
            }
        }
        
        return cell;
    }
}

