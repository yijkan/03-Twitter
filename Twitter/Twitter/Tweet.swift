//
//  Tweet.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    static var sourceDateFormat = "EEE MMM d HH:mm:ss Z y"
    static var dateFormat = "EEE MMM d y HH:mm"
    
    var id:String?
    var user:User?
    var text:String?
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
    var likes:Int = 0
    
    init(dictionary: NSDictionary) {
        id = dictionary["id_str"] as? String
        if let userData = dictionary["user"] as? NSDictionary {
            user = User(dictionary: userData)
        }
        text = dictionary["text"] as? String
        let createdAtString = dictionary["created_at"] as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = Tweet.sourceDateFormat
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