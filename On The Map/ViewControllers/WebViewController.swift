//
//  WebViewController.swift
//  On The Map
//
//  Created by mitul jindal on 09/09/17.
//  Copyright © 2017 mitul jindal. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    var urlString: String?
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        
        guard let url = URL(string: urlString!) else {
            return
        }
    
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
    
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("dzfbgdn")
//        print(webView.request!.url!.absoluteString)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("finish")
    }
}

