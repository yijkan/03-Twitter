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
    var loadCount = 0 // how many infinite scroll loads we've done
    var isLoadingMore:Bool = false
    var loadingMoreView:InfiniteScrollActivityView? // the view when infinite scroll loading
    @IBOutlet weak var tweetsTableView: UITableView!
    var refreshControl:UIRefreshControl!
    
    func reload(ofUser:User?, useHUD:Bool) {
        if useHUD {
            MBProgressHUD.showHUDAddedTo(self.view, animated:true)
        }
        let screenName:String?
        if ofUser == nil || ofUser!.handle == nil {
            screenName = nil
        } else {
            screenName = ofUser!.handle!
        }
        
        TwitterClient.sharedInstance.timeline(loadCount, screenName: screenName, success: { (tweets:[Tweet]) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            }, failure: failureClosure, completion: { () in
                if useHUD {
                    MBProgressHUD.hideHUDForView(self.view, animated:true)
                }
                self.refreshControl.endRefreshing()
                self.isLoadingMore = false
                self.loadingMoreView!.stopAnimating()
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
        
        /***** for infinite scroll *****/
        let frame = CGRectMake(0, tweetsTableView.contentSize.height, tweetsTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tweetsTableView.addSubview(loadingMoreView!)
        
        var insets = tweetsTableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tweetsTableView.contentInset = insets
        
        reload(nil, useHUD: true)
        
        NSNotificationCenter.defaultCenter().addObserverForName(User.userDidLogoutNotif, object: nil, queue: NSOperationQueue.mainQueue()) { (notification: NSNotification) in
            self.userChanged = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if (userChanged) {
            reload(nil, useHUD: true)
            userChanged = false
        }
    }
    
    /*** pull to refresh ***/
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadCount = 1
        reload(nil, useHUD: false)
    }
    
    /***** For Infinite Scroll *****/
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isLoadingMore) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tweetsTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tweetsTableView.bounds.size.height
            
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tweetsTableView.dragging) {
                isLoadingMore = true
                
                let frame = CGRectMake(0, tweetsTableView.contentSize.height, tweetsTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadCount += 1
                reload(nil, useHUD: false)
            }
            
        }
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
