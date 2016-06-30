//
//  TweetCell.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            let user = tweet.user
            
            if let profileURL:NSURL = user?.profileURL {
                profileImageView.setImageWithURLRequest(NSURLRequest(URL: profileURL), placeholderImage: nil, success: { (request:NSURLRequest, response:NSHTTPURLResponse?, image:UIImage) in
                        self.profileImageView.image = image
                    }, failure: { (request:NSURLRequest, response:NSHTTPURLResponse?, error:NSError) in
                        print("Error: " + error.localizedDescription)
                })
            }
            let name = (user?.name)!
            let handle = (user?.handle)!
            let author = NSMutableAttributedString(string: name + " @" + handle)
            author.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, name.characters.count))
            author.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(16, weight: UIFontWeightSemibold), range: NSMakeRange(0, name.characters.count))
            author.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSMakeRange(name.characters.count+1, handle.characters.count+1))
            authorLabel.attributedText = author
            tweetLabel.text = tweet.text
            
            let createdAt = tweet.createdAt
            timestampLabel.text = createdAt?.relativeTime 
        }
    }
}
