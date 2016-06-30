//
//  DetailsViewController.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    var tweet:Tweet!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!

    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    let retweetedFalseImage = UIImage(named: "retweet-action")
    let favoritedFalseImage = UIImage(named: "like-action")
    let repliedFalseImage = UIImage(named: "reply-action_0")
    let retweetedTrueImage = UIImage(named: "retweet-action-on")
    let favoritedTrueImage = UIImage(named: "like-action-on")
    let repliedTrueImage = UIImage(named: "reply-action-pressed_0")
    
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
        nameLabel.text = user?.name
        if let handle = user?.handle {
            handleLabel.text = "@" + handle
        }
        tweetLabel.text = tweet.text
        timestampLabel.text = tweet.absoluteTimestamp
    }
    
    // ??? WTF the image won't get set...
    override func viewWillAppear(animated: Bool) {
        if tweet.liked {
            print("tweet was liked")
            favoriteButton.imageView!.image = favoritedTrueImage
        } else {
            favoriteButton.imageView!.image = favoritedFalseImage
        }
        if tweet.retweeted {
            print("tweet was retweeted")
            retweetButton.imageView!.image = retweetedTrueImage
        } else {
            retweetButton.imageView!.image = retweetedFalseImage
        }
    }
    
    @IBAction func onRetweet(sender: UIButton) {
        TwitterClient.sharedInstance.retweet(tweet.id, success: {
                self.tweet.retweeted = true
                self.retweetButton.imageView!.image = self.retweetedTrueImage
            }, failure: failureClosure
        )
    }
    
    @IBAction func onFavorite(sender: UIButton) {
        let tweetID:String!
        if let originalDict = tweet.originalDict {
            let original = Tweet(dictionary: originalDict)
            tweetID = original.id
        } else {
            tweetID = tweet.id
        }
        TwitterClient.sharedInstance.favorite(tweetID, success: {
                self.tweet.liked = true
                self.favoriteButton.imageView!.image = self.favoritedTrueImage
            }, failure: failureClosure
        )

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
extension DetailsViewController : TweetDelegate {
    func postedTweet(tweetText: String) {
        self.replyButton.imageView!.image = self.repliedTrueImage
    }
}
