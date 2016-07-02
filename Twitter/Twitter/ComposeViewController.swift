//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    var delegate: TweetDelegate!
    var replyTo: Tweet? = nil
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tweetingAsLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var charsRemainingLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    
    @IBOutlet weak var charCountBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var charsBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.titleLabel!.font = labelFont(16)
        tweetingAsLabel.font = labelFont(16)
        
        userLabel.font = labelFont(16)
        userLabel.text = User.currentUser?.name
        
        charCountLabel.font = labelFont(14)
        charsRemainingLabel.font = labelFont(14)
        
        tweetTextView.font = textFont(16)
        tweetTextView.layer.cornerRadius = 5
//        tweetTextView.layer.borderColor = UIColor.blackColor()
        tweetTextView.layer.borderWidth = 1
        tweetTextView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
        if let replyTo = replyTo {
            tweetTextView.text = "@\(replyTo.user!.handle!) "
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        charCountLabel.text = "\(140 - tweetTextView.text.characters.count)"
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }
 
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardFrame = userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        let keyboardHeight = keyboardFrame?.size.height
        
        charCountBottomConstraint.constant = keyboardHeight! + 8
        charsBottomConstraint.constant = keyboardHeight! + 8
        buttonBottomConstraint.constant = keyboardHeight! + 8
        view.layoutIfNeeded()
    }
    
    func keyboardWillHide(notification: NSNotification) {
        charCountBottomConstraint.constant = 8
        charsBottomConstraint.constant = 8
        buttonBottomConstraint.constant = 8
        view.layoutIfNeeded()
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        view.endEditing(true)
        let tweet = tweetTextView.text
        if tweet.characters.count > 140 {
            // TODO tweet is too long?
            // Also question marks don't seem to work
            print("tweet is too long!")
        } else {
            if let replyTo = replyTo {
                TwitterClient.sharedInstance.reply(replyTo, tweetText: tweet, success: {
                    self.dismissViewControllerAnimated(true, completion: {self.delegate.postedTweet(tweet)})
                    }, failure: failureClosure
                )
            } else {
                TwitterClient.sharedInstance.tweet(tweet, success: {
                    self.dismissViewControllerAnimated(true, completion: {self.delegate.postedTweet(tweet)})
                    }, failure: failureClosure
                )
            }
       }
    }
    
}

protocol TweetDelegate {
    func postedTweet(tweetText: String) 
}