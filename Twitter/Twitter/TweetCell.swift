//
//  TweetCell.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import AFNetworking

class TweetCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
//    @IBOutlet weak var tweetLabel: TTTAttributedLabel! // !!!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    // !!!
//    func viewDidLoad() {
//        tweetLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
//    }
    
    var tweet: Tweet! {
        didSet {
            let user = tweet.user
            
            if let profileURL:NSURL = user?.profileURL {
                profileImageView.setImageWithURLRequest(NSURLRequest(URL: profileURL), placeholderImage: nil, success: { (request:NSURLRequest, response:NSHTTPURLResponse?, image:UIImage) in
                        self.profileImageView.image = image
                    }, failure: { (request:NSURLRequest, response:NSHTTPURLResponse?, error:NSError) in
                        failureClosure(error)
                })
            }
            authorLabel.attributedText = user?.attributedNameAndHandle
                    tweetLabel.text = tweet.text // !!!
//            tweetLabel.setText(tweet.attributedText)
            timestampLabel.text = tweet.relativeTimestamp
        }
    }
}
