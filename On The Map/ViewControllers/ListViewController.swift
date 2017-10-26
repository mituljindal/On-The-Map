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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload(notification:)), name: .updatedLocations, object: nil)
    }
    
    @objc func reload(notification: NSNotification) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UdacityClient.sharedInstance.locationsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")!
        let location = UdacityClient.sharedInstance.locationsArray[indexPath.row]
        
        cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let url = URL(string:(UdacityClient.sharedInstance.locationsArray[indexPath.row]).mediaURL) else {return}
        if(UIApplication.shared.canOpenURL(url)) {
            UIApplication.shared.open(url, options: [:])
        } else {
            presentAlert(title: "Broken link", error: "Looks like the user has not specified a proper social link")
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        (self.tabBarController as? TabBarViewController)?.logout()
    }
    
    @IBAction func refresh(_ sender: Any) {
        (self.tabBarController as? TabBarViewController)?.refresh()
    }
}

