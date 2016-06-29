//
//  FeedViewController.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    var tweetReuseID = "tweet"
    var tweets: [Tweet]!
    @IBOutlet weak var tweetsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetsTableView.dataSource = self
        tweetsTableView.delegate = self
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets:[Tweet]) in
                self.tweets = tweets
                self.tweetsTableView.reloadData()
            }, failure: { (error:NSError) in
                print("Error: " + error.localizedDescription)
            }
        )
    }
    
    @IBAction func onLogout(sender: UIBarButtonItem) {
        TwitterClient.sharedInstance.logout()
    }
    
    
}

extension FeedViewController:UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweet") as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}

extension FeedViewController:UITableViewDelegate {
    
}
