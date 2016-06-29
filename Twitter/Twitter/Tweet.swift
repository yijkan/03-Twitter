//
//  Tweet.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    var user:User?
    var text:String?
    var createdAt:NSDate?
    var retweets:Int = 0
    var likes:Int = 0
    
    static var dateFormat = "EEE MMM d HH:mm:ss Z y"
    
    init(dictionary: NSDictionary) {
        if let userData = dictionary["user"] as? NSDictionary {
            user = User(dictionary: userData)
        }
        text = dictionary["text"] as? String
        let createdAtString = dictionary["created_at"] as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = Tweet.dateFormat
        if let createdAtString = createdAtString {
            createdAt = formatter.dateFromString(createdAtString)
        }
        
        retweets = (dictionary["retweet_count"] as? Int) ?? 0
        likes = (dictionary["favourites_count"] as? Int) ?? 0
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