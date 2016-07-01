//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProfileViewController: FeedViewController {
    
    var user:User!
    
    override func reload(ofUser:User?, useHUD:Bool) {
        user.reload({ (user) in
                self.user = user
                super.reload(user, useHUD: useHUD)
            }, failure: failureClosure
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return super.tableView(tableView, numberOfRowsInSection: section) + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("profile") as! ProfileCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.user = user
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("tweet") as! TweetCell
            cell.tweet = tweets[indexPath.row - 1]
            return cell
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        super.prepareForSegue(segue, sender: sender)
//    }
    
    override func postedTweet(tweetText: String) {
        user.numTweets! += 1
        super.postedTweet(tweetText)
    }
    
}