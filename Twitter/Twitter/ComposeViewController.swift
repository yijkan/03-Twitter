//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLabel.text = User.currentUser?.name
        tweetTextView.layer.cornerRadius = 5
//        tweetTextView.layer.borderColor = UIColor.blackColor()
        tweetTextView.layer.borderWidth = 1
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        let tweet = tweetTextView.text
        TwitterClient.sharedInstance.tweet(tweet, success: {self.dismissViewControllerAnimated(true, completion: nil)}, failure: {(error:NSError) in print("Error:" + error.localizedDescription)})
    // TODO: Notification that new tweet has been posted
    }
    
}
