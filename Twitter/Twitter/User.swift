//
//  User.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject {
    var dict: NSDictionary
    var name: String?
    var handle: String?
    var attributedNameAndHandle: NSAttributedString? {
        get {
            let nameSub = name ?? ""
            let handleSub = "@" + (handle ?? "")
            let attributed = NSMutableAttributedString(string: nameSub + " " + handleSub)
            // make name black & bold
            attributed.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, nameSub.characters.count))
            attributed.addAttribute(NSFontAttributeName, value: boldFont(16), range: NSMakeRange(0, nameSub.characters.count))
            // make handle gray & regular
            attributed.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSMakeRange(nameSub.characters.count+1, handleSub.characters.count))
            attributed.addAttribute(NSFontAttributeName, value: labelFont(16), range: NSMakeRange(nameSub.characters.count+1, handleSub.characters.count))
            return attributed
        }
    }
    var largeAttributedNameAndHandle: NSAttributedString? {
        get {
            let nameSub = name ?? ""
            let handleSub = "@" + (handle ?? "")
            let attributed = NSMutableAttributedString(string: nameSub + "\n" + handleSub)
            attributed.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, nameSub.characters.count))
            attributed.addAttribute(NSFontAttributeName, value: boldFont(20), range: NSMakeRange(0, nameSub.characters.count))
            attributed.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSMakeRange(nameSub.characters.count+1, handleSub.characters.count))
            attributed.addAttribute(NSFontAttributeName, value: labelFont(18), range: NSMakeRange(nameSub.characters.count+1, handleSub.characters.count))
            return attributed
        }
    }
    var desc: String?
    var profileURL: NSURL?
    var numTweets: Int?
    var numFollowing: Int?
    var numFollowers: Int?
    var following: Bool?
    
    init(dictionary: NSDictionary) {
        dict = dictionary
        name = dictionary["name"] as? String
        handle = dictionary["screen_name"] as? String
        desc = dictionary["description"] as? String
        
        if let profileURLString = dictionary["profile_image_url_https"] as? String {
            let modifiedProfileURLString = profileURLString.stringByReplacingOccurrencesOfString("_normal", withString: "_bigger")
            profileURL = NSURL(string: modifiedProfileURLString)
        }
        numTweets = dictionary["statuses_count"] as? Int
        numFollowing = dictionary["friends_count"] as? Int
        numFollowers = dictionary["followers_count"] as? Int
        following = dictionary["following"] as? Bool
    }
    
    func reload(success: ((User) -> ()), failure: ((NSError) -> ())) {
        TwitterClient.sharedInstance.loadUserData(handle, success: success, failure: failure)
    }
    
    static var _currentUser: User?
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                if let userData = userData {
                    let dict = try!NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dict)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dict, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    
    static let userDidLogoutNotif = "userDidLogout"
}