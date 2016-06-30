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
    var userChanged:Bool = false
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
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tweetsTableView.insertSubview(refreshControl, atIndex: 0)
        
        loadTweets(true)
        
        NSNotificationCenter.defaultCenter().addObserverForName(User.userDidLogoutNotif, object: nil, queue: NSOperationQueue.mainQueue()) { (notification: NSNotification) in
            self.userChanged = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if (userChanged) {
            loadTweets(true)
            userChanged = false
        }
    }
    
    /*** pull to refresh ***/
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadTweets(false)
    }
    
    @IBAction func onLogout(sender: UIBarButtonItem) {
        TwitterClient.sharedInstance.logout()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tweetDetails" {
            if let cell = sender as? TweetCell {
                let vc = segue.destinationViewController as! DetailsViewController
                vc.tweet = cell.tweet
            }
        } else if segue.identifier == "New" {
            let vc = segue.destinationViewController as! ComposeViewController
            vc.delegate = self
        }
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
    }
}

extension FeedViewController:UITableViewDelegate {
    
}

extension FeedViewController : TweetDelegate {
    func postedTweet(tweetText: String) {
        tweets.insert(Tweet.init(tweetText: tweetText), atIndex: 0)
        tweetsTableView.reloadData()
    }
}
