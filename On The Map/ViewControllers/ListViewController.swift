//
//  StudentsTableViewController.swift
//  On The Map
//
//  Created by mitul jindal on 14/09/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var locationsArray: [[String: AnyObject]]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload(notification:)), name: .updatedLocations, object: nil)
        self.locationsArray = appDelegate.locationsArray
    }
    
    @objc func reload(notification: NSNotification) {
        self.locationsArray = appDelegate.locationsArray
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locationsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")!
        let location = self.locationsArray[indexPath.row]
        
        cell.textLabel?.text = "\(location["firstName"] ?? "No First Name" as AnyObject) \(location["lastName"] ?? "No Last Name" as AnyObject)"
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var controller: WebViewController
        controller = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        
        controller.urlString = (self.locationsArray[indexPath.row])["mediaURL"] as? String
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        (self.tabBarController as? TabBarViewController)?.logout()
    }
    
    @IBAction func refresh(_ sender: Any) {
        (self.tabBarController as? TabBarViewController)?.refresh()
    }
}

