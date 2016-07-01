//
//  Tweet.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import Foundation
import UIKit

class Tweet: NSObject {
    static var sourceDateFormat = "EEE MMM d HH:mm:ss Z y"
    static var dateFormat = "EEE MMM d y HH:mm"
    
    var id:String?
    var user:User?
    var text:String?
    var urls:[Url]?
    // !!!
    var attributedText:NSMutableAttributedString? {
        get {
            if text == nil {
                return nil
            }
            let attributed = NSMutableAttributedString(string: text!)
            if urls == nil {
                return attributed
            }
            for url in urls! {
                if url.expandedURL != nil && url.indices != nil {
                    attributed.addAttribute(NSLinkAttributeName, value: url.expandedURL!, range: NSMakeRange(url.indices!.0, url.indices!.1 - url.indices!.0)) // !!! this doesn't actually make it clickable
                }
            }
            return attributed
        }
    }
    var createdAt:NSDate?
    var relativeTimestamp:String? {
        get {
            return createdAt?.relativeTime
        }
    }
    var absoluteTimestamp:String? {
        get {
            if let createdAt = createdAt {
                let formatter = NSDateFormatter()
                formatter.dateFormat = Tweet.dateFormat
                return formatter.stringFromDate(createdAt)
            } else {
                return nil
            }
        }
    }
    var retweets:Int = 0
    var retweeted:Bool = false
    var likes:Int = 0
    var liked:Bool = false
    
    var originalDict:NSDictionary? = nil
    
    init(tweetText:String) {
        user = User.currentUser
        text = tweetText
        urls = []
        let date = NSDate()
        let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: date)
        createdAt = NSCalendar.currentCalendar().dateFromComponents(components)
    }
    
    init(dictionary: NSDictionary) {
        id = dictionary["id_str"] as? String
        if let userData = dictionary["user"] as? NSDictionary {
            user = User(dictionary: userData)
        }
        text = dictionary["text"] as? String
        if let entities = dictionary["entities"] as? NSDictionary {
            if let urls = entities["urls"] as? [NSDictionary] {
                self.urls = Url.dicts2URLs(urls)
            }
        }
        let createdAtString = dictionary["created_at"] as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = Tweet.sourceDateFormat
        if let createdAtString = createdAtString {
            createdAt = formatter.dateFromString(createdAtString)
        }
        
        retweets = (dictionary["retweet_count"] as? Int) ?? 0
        retweeted = (dictionary["retweeted"] as! Bool) ?? false
        likes = (dictionary["favourites_count"] as? Int) ?? 0
        liked = (dictionary["favorited"] as! Bool) ?? false
        
        originalDict = dictionary["retweeted_status"] as? NSDictionary
    }
    
    class func tweetsFromArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dict in dictionaries {
            let tweet = Tweet(dictionary: dict)
            tweets.append(tweet)
        }
        return tweets
    }
}