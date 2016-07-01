//
//  DetailsViewController.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class DetailsViewController: UIViewController {
    var tweet:Tweet!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
//    @IBOutlet weak var tweetLabel: UILabel! 
//    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var tweetLabel: TTTAttributedLabel!
    
    @IBOutlet weak var timestampLabel: UILabel!

    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var retweetsNum: UILabel!
    @IBOutlet weak var likesNum: UILabel!
    
    var delegate: WebViewDelegate!
    
    let retweetedFalseImage = UIImage(named: "retweet-action")
    let favoritedFalseImage = UIImage(named: "like-action")
    let repliedFalseImage = UIImage(named: "reply-action_0")
    let retweetedTrueImage = UIImage(named: "retweet-action-on")
    let favoritedTrueImage = UIImage(named: "like-action-on")
    let repliedTrueImage = UIImage(named: "reply-action-pressed_0")
    
    let blueImage = UIImage(named:"blue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = tweet.user
        if let profileURL = user?.profileURL {
            profileImageView.setImageWithURLRequest(NSURLRequest(URL:profileURL), placeholderImage: nil, success: { (request:NSURLRequest, response:NSHTTPURLResponse?, image:UIImage) in
                    self.profileImageView.image = image
                }, failure: { (request:NSURLRequest, response:NSHTTPURLResponse?, error:NSError) in
                    failureClosure(error)
            })
        }
        nameLabel.font = boldFont(18)
        nameLabel.text = user?.name
        handleLabel.font = labelFont(18)
        if let handle = user?.handle {
            handleLabel.text = "@" + handle
        }

        tweetLabel.font = textFont(16)
        tweetLabel.delegate = self
        tweetLabel.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
        tweetLabel.setText(tweet.text)
        
        timestampLabel.font = labelFont(14)
        timestampLabel.text = tweet.absoluteTimestamp
        
        retweetsNum.font = labelFont(14)
        retweetsNum.text = "\(tweet.retweets)"
        likesNum.font = labelFont(14)
        likesNum.text = "\(tweet.likes)"
    }
    
    override func viewWillAppear(animated: Bool) {
        if tweet.liked {
            favoriteButton.setImage(favoritedTrueImage, forState: .Normal)
            likesNum.textColor = redColor
        } else {
            favoriteButton.setImage(favoritedFalseImage, forState: .Normal)
            likesNum.textColor = grayColor
        }
        if tweet.retweeted {
            retweetButton.setImage(retweetedTrueImage, forState: .Normal)
            retweetsNum.textColor = greenColor
        } else {
            retweetButton.setImage(retweetedFalseImage, forState: .Normal)
            retweetsNum.textColor = grayColor
        }
        replyButton.setImage(repliedFalseImage, forState: .Normal)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    @IBAction func onRetweet(sender: UIButton) {
        if tweet.retweeted {
            TwitterClient.sharedInstance.unretweet(tweet.id, success: {
                    self.tweet.retweets -= 1
                    self.tweet.retweeted = false
                    self.retweetsNum.text = "\(Int(self.retweetsNum.text!)! - 1)"
                    self.retweetsNum.textColor = grayColor
                    self.retweetButton.setImage(self.retweetedFalseImage, forState: .Normal)
                }, failure: failureClosure
            )
        } else {
            TwitterClient.sharedInstance.retweet(tweet.id, success: {
                    self.tweet.retweets += 1
                    self.tweet.retweeted = true
                    self.retweetsNum.text = "\(Int(self.retweetsNum.text!)! + 1)"
                    self.retweetsNum.textColor = greenColor
                    self.retweetButton.setImage(self.retweetedTrueImage, forState: .Normal)
                }, failure: failureClosure
            )
        }
    }
    
    @IBAction func onFavorite(sender: UIButton) {
        let tweetID:String!
        if let originalDict = tweet.originalDict {
            let original = Tweet(dictionary: originalDict)
            tweetID = original.id
        } else {
            tweetID = tweet.id
        }
        if tweet.liked {
            TwitterClient.sharedInstance.unfavorite(tweetID, success: {
                    self.tweet.likes -= 1
                    self.likesNum.text = "\(Int(self.likesNum.text!)! - 1)"
                    self.tweet.liked = false
                    self.likesNum.textColor = grayColor
                    self.favoriteButton.setImage(self.favoritedFalseImage, forState: .Normal)
                }, failure: failureClosure
            )
        } else {
            TwitterClient.sharedInstance.favorite(tweetID, success: {
                    self.tweet.likes += 1
                    self.likesNum.text = "\(Int(self.likesNum.text!)! + 1)"
                    self.tweet.liked = true
                    self.likesNum.textColor = redColor
                    self.favoriteButton.setImage(self.favoritedTrueImage, forState: .Normal)
                }, failure: failureClosure
            )
        }

    }
    
    @IBAction func onReply(sender: UIButton) {
        performSegueWithIdentifier("reply", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "profile" {
            let vc = segue.destinationViewController as! OtherViewController
            vc.user = tweet.user
        } else if segue.identifier == "reply" {
            let vc = segue.destinationViewController as! ComposeViewController
            vc.delegate = self
            vc.replyTo = tweet
        }
    }
}

extension DetailsViewController: TTTAttributedLabelDelegate {
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        delegate.openLink(url)
    }
}

extension DetailsViewController : TweetDelegate {
    func postedTweet(tweetText: String) {
        self.replyButton.imageView!.image = self.repliedTrueImage
    }
}
