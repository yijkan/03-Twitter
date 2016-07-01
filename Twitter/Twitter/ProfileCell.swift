//
//  ProfileCell.swift
//  Twitter
//
//  Created by Yijin Kang on 6/30/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
    var user:User! {
        didSet {
            if let profileURL = user.profileURL {
                profileImageView.setImageWithURLRequest(NSURLRequest(URL: profileURL), placeholderImage: nil, success: { (request:NSURLRequest, response:NSHTTPURLResponse?, image:UIImage) in
                        self.profileImageView.image = image
                    }, failure: { (request:NSURLRequest, response:NSHTTPURLResponse?, error:NSError) in
                        failureClosure(error)
                    }
                )
            }
                
            nameLabel.attributedText = user.largeAttributedNameAndHandle
            descLabel.text = user.desc
            tweetsNumLabel.text = "\(user.numTweets ?? 0)"
            followingNumLabel.text = "\(user.numFollowing ?? 0)"
            followersNumLabel.text = "\(user.numFollowers ?? 0)"
        }
    }
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tweetsNumLabel: UILabel!
    @IBOutlet weak var followingNumLabel: UILabel!
    @IBOutlet weak var followersNumLabel: UILabel!
}
