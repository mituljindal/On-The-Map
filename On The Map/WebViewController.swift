//
//  WebViewController.swift
//  On The Map
//
//  Created by mitul jindal on 09/09/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    let url = URL(string: "https://www.udacity.com/account/auth#!/signup")
    
    override func viewDidLoad() {
    
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
