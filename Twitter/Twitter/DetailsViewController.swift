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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = tweet.user
        if let profileURL = user?.profileURL {
            profileImageView.setImageWithURLRequest(NSURLRequest(URL:profileURL), placeholderImage: nil, success: { (request:NSURLRequest, response:NSHTTPURLResponse?, image:UIImage) in
                    self.profileImageView.image = image
                }, failure: { (request:NSURLRequest, response:NSHTTPURLResponse?, error:NSError) in
                    print("Error: " + error.localizedDescription)
            })
        }
        nameLabel.text = user?.name
        if let handle = user?.handle {
            handleLabel.text = "@" + handle
        }
        tweetLabel.text = tweet.text
        timestampLabel.text = tweet.absoluteTimestamp
    }
    
    @IBAction func onRetweet(sender: UIButton) {
        TwitterClient.sharedInstance.retweet(tweet.id, success: {
                // TODO indication of RT
                print("RT")
            }, failure: {(error) in
                print("Error: " + error.localizedDescription)
            }
        )
    }
    
    @IBAction func onFavorite(sender: UIButton) {
        TwitterClient.sharedInstance.favorite(tweet.id, success: {
                // TODO indication of fav
                print("fav")
            }, failure: {(error) in
                print("Error: " + error.localizedDescription)
            }
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
        // TODO indication of reply
        // turn the replied button on?
    }
}
