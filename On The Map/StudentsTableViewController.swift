//
//  StudentsTableViewController.swift
//  On The Map
//
//  Created by mitul jindal on 14/09/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit

class StudentTableViewController: UITableViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.locationsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")!
        let location = appDelegate.locationsArray[indexPath.row]
        
        cell.textLabel?.text = "\(location["firstName"] ?? "No First Name" as AnyObject) \(location["lastName"] ?? "No Last Name" as AnyObject)"
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var controller: WebViewController
        controller = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        
        controller.urlString = (appDelegate.locationsArray[indexPath.row])["mediaURL"] as? String
        present(controller, animated: true, completion: nil)
    }
}

