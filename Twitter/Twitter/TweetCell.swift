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
    @IBOutlet weak var tweetLabel: TTTAttributedLabel!
    // !!!
//    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var delegate: WebViewDelegate!
    
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
//            authorLabel.font = labelFont(16)
            authorLabel.attributedText = user?.attributedNameAndHandle
            
            timestampLabel.text = tweet.relativeTimestamp
            timestampLabel.font = labelFont(12)
            
            tweetLabel.delegate = self
            tweetLabel.font = textFont(14)
            tweetLabel.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
            tweetLabel.setText(tweet.text)

        }
    }
    
}

extension TweetCell: TTTAttributedLabelDelegate {
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        delegate.openLink(url)
    }
}

protocol WebViewDelegate {
    func openLink(url: NSURL)
}
