//
//  FeedViewController.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import MBProgressHUD

class FeedViewController: UIViewController {
    var tweetReuseID = "tweet"
    var tweets: [Tweet]!
    @IBOutlet weak var tweetsTableView: UITableView!
    var refreshControl:UIRefreshControl!
    
    func loadTweets(useHUD:Bool) {
        if useHUD {
            MBProgressHUD.showHUDAddedTo(self.view, animated:true)
        }
        TwitterClient.sharedInstance.homeTimeline({ (tweets:[Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            }, failure: { (error:NSError) in
                print("Error: " + error.localizedDescription)
            }, completion: { () in
                if useHUD {
                    MBProgressHUD.hideHUDForView(self.view, animated:true)
                }
                self.refreshControl.endRefreshing()
            }
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetsTableView.dataSource = self
        tweetsTableView.delegate = self
        
        /*** pull to refresh ***/
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tweetsTableView.insertSubview(refreshControl, atIndex: 0)
        
        loadTweets(true)
    }
    
    /*** pull to refresh ***/
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadTweets(false)
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        // TODO segue to details view
    }
}

extension FeedViewController:UITableViewDelegate {
    
}
