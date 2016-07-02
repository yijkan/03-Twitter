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
    var unfollowButton: UIButton = UIButton(type: UIButtonType.Custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        followButton.setImage(UIImage(named: "follow"), forState: UIControlState.Normal)
        followButton.addTarget(self, action: #selector(onFollow), forControlEvents: UIControlEvents.TouchUpInside)
        followButton.frame = CGRectMake(0, 0, 48, 30)
        
        unfollowButton.setImage(UIImage(named: "following"), forState: UIControlState.Normal)
        unfollowButton.addTarget(self, action: #selector(onUnfollow), forControlEvents: UIControlEvents.TouchUpInside)
        unfollowButton.frame = CGRectMake(0, 0, 48, 30)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if user == User.currentUser {
            self.navigationItem.rightBarButtonItem = nil
        } else if user.following != nil && user.following! {
            // show unfollow button
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: unfollowButton)
        } else {
            // show follow button
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: followButton)
        }
    }
    
    func onFollow(sender: AnyObject) {
        print("follow")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: unfollowButton)
        user.following = true
    }
    
    func onUnfollow(sender: AnyObject) {
        print("unfollow")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: followButton)
        user.following = false
    }
    
}
