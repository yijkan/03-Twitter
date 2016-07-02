//
//  OtherViewController.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit

class OtherViewController: ProfileViewController {
    var followButton: UIButton = UIButton(type: UIButtonType.Custom)
    var followBarButton: UIBarButtonItem!
    var unfollowButton: UIButton = UIButton(type: UIButtonType.Custom)
    var unfollowBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followButton.setImage(UIImage(named: "follow"), forState: UIControlState.Normal)
        followButton.addTarget(self, action: #selector(onFollow), forControlEvents: UIControlEvents.TouchUpInside)
        followButton.frame = CGRectMake(0, 0, 48, 30)
        followBarButton = UIBarButtonItem(customView: self.followButton)
        
        unfollowButton.setImage(UIImage(named: "following"), forState: UIControlState.Normal)
        unfollowButton.addTarget(self, action: #selector(onUnfollow), forControlEvents: UIControlEvents.TouchUpInside)
        unfollowButton.frame = CGRectMake(0, 0, 48, 30)
        unfollowBarButton = UIBarButtonItem(customView: self.unfollowButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if user.handle == User.currentUser!.handle {
            self.navigationItem.rightBarButtonItem?.enabled = false
        } else if user.following != nil && user.following! {
            // show unfollow button
            self.navigationItem.rightBarButtonItem = unfollowBarButton
            self.navigationItem.rightBarButtonItem?.enabled = true
        } else {
            // show follow button
            self.navigationItem.rightBarButtonItem = followBarButton
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    
    func onFollow(sender: AnyObject) {
        TwitterClient.sharedInstance.follow(user.handle!, success: { () in
                self.navigationItem.rightBarButtonItem = self.unfollowBarButton
                self.user.following = true
                print("followed")
            }, failure: failureClosure, completion: {
                
            }
        )
    }
    
    func onUnfollow(sender: AnyObject) {
        TwitterClient.sharedInstance.follow(user.handle!, success: { () in
                self.navigationItem.rightBarButtonItem = self.followBarButton
                self.user.following = false
                print("unfollowed")
            }, failure: failureClosure, completion: {
                
            }
        )
    }
    
}
