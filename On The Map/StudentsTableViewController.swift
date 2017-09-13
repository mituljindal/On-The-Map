//
//  StudentsTableViewController.swift
//  On The Map
//
//  Created by mitul jindal on 14/09/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {
    
    var locationsArray: [[String: AnyObject]]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.locationsArray = appDelegate.locationsArray
        
        print("reloading")
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("row count")
        return locationsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")!
        let location = locationsArray[indexPath.row]
        print("adding cell \(indexPath.row)")
        
        cell.textLabel?.text = "\(location["firstName"] ?? "No First Name" as AnyObject) \(location["lastName"] ?? "No Last Name" as AnyObject)"
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        //        cell.detailTextLabel?.text = location["mediaURL"] as? String
        //        cell.detailTextLabel?.isHidden = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var controller: WebViewController
        controller = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        
        controller.urlString = (locationsArray[indexPath.row])["mediaURL"] as? String
        present(controller, animated: true, completion: nil)
    }
}

