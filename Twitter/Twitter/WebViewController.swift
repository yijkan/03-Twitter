//
//  WebViewController.swift
//  Twitter
//
//  Created by Yijin Kang on 7/1/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    @IBOutlet var webView: UIWebView!
    var request:NSURLRequest!
    var url:NSURL! {
        didSet {
            request = NSURLRequest(URL:url)
            
        }
    }
    
    override func viewDidLoad() {
        webView.loadRequest(request)
        self.navigationController?.hidesBarsOnSwipe = true
    }
}
