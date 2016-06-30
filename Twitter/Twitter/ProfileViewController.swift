//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit

class ProfileViewController: FeedViewController {
    var user:User!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tweetsNumLabel: UILabel!
    @IBOutlet weak var followingNumLabel: UILabel!
    @IBOutlet weak var followersNumLabel: UILabel!
    
    override func viewDidLoad() {
        user = User.currentUser
        
        if let profileURL = user.profileURL {
            profileImageView.setImageWithURLRequest(NSURLRequest(URL: profileURL), placeholderImage: nil, success: { (request:NSURLRequest, response:NSHTTPURLResponse?, image:UIImage) in
                    self.profileImageView.image = image
                }, failure: { (request:NSURLRequest, response:NSHTTPURLResponse?, error:NSError) in
                    print("Error: " + error.localizedDescription)
            })
        }
        
        nameLabel.attributedText = user.attributedNameAndHandle
        descLabel.text = user.desc
        tweetsNumLabel.text = "\(user.numTweets ?? 0)"
        followingNumLabel.text = "\(user.numFollowing ?? 0)"
        followersNumLabel.text = "\(user.numFollowers ?? 0)"
        
        // load posts
    }
    
    
}