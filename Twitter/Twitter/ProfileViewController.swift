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
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tweetsNumLabel: UILabel!
    @IBOutlet weak var followingNumLabel: UILabel!
    @IBOutlet weak var followersNumLabel: UILabel!
    
    func setUser() {
        
    }
    
    func setViews() {
        if let profileURL = user.profileURL {
            profileImageView.setImageWithURLRequest(NSURLRequest(URL: profileURL), placeholderImage: nil, success: { (request:NSURLRequest, response:NSHTTPURLResponse?, image:UIImage) in
                self.profileImageView.image = image
                }, failure: { (request:NSURLRequest, response:NSHTTPURLResponse?, error:NSError) in
                    failureClosure(error)
            })
        }
        
        nameLabel.attributedText = user.largeAttributedNameAndHandle
        descLabel.text = user.desc
        tweetsNumLabel.text = "\(user.numTweets ?? 0)"
        followingNumLabel.text = "\(user.numFollowing ?? 0)"
        followersNumLabel.text = "\(user.numFollowers ?? 0)"
    }
    
    override func reload(ofUser:User?, useHUD:Bool) {
        user.reload({ (user) in
            self.user = user
            self.setViews()
            super.reload(user, useHUD: useHUD)
            }, failure: failureClosure
        )
    }
    
    override func viewDidLoad() {
        setUser()
        setViews()
        super.viewDidLoad()
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        super.prepareForSegue(segue, sender: sender)
//    }
    
    override func postedTweet(tweetText: String) {
        super.postedTweet(tweetText)
        
        let numTweets:Int = Int(tweetsNumLabel.text!)!
        tweetsNumLabel.text = "\(numTweets+1)"
    }
    
}