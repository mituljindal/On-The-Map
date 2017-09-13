//
//  TableViewController.swift
//  On The Map
//
//  Created by mitul jindal on 13/09/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    var urlString: String!
    var locationsArray: [[String: AnyObject]]!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.locationsArray = appDelegate.locationsArray
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell")!
        let location = locationsArray[indexPath.row]
        
        cell.textLabel?.text = "\(location["firstName"] ?? "No First Name" as AnyObject) \(location["lastName"] ?? "No Last Name" as AnyObject)"
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        self.urlString = location["mediaURL"] as! String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var controller: WebViewController
        controller = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        
        controller.urlString = self.urlString
        present(controller, animated: true, completion: nil)    }
}
