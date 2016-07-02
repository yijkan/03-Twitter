//
//  TwitterClient.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    /*** string constants ***/
    static let baseURLString = "https://api.twitter.com"
    static let consumerKey = "XtSw9EAK44ydjex2w0sqpJCUE"
    static let consumerSecret = "sZtcBhSdWQ2hTkQl9O5L5TgdunDtLf6R2Veq970hREl3XFcEkG"
    
    static let requestTokenPath = "oauth/request_token"
    static let authorizeURL = "https://api.twitter.com/oauth/authorize?oauth_token="
    
    static let accessTokenPath = "oauth/access_token"
    
    static let verifyPath = "1.1/account/verify_credentials.json"
    static let showUserPath = "1.1/users/show.json"
    static let followPath = "1.1/friendships/create.json"
    static let unfollowPath = "1.1/friendships/destroy.json"
    static let homeTimelinePath = "1.1/statuses/home_timeline.json"
    static let userTimelinePath = "1.1/statuses/user_timeline.json"
    static let updatePath = "1.1/statuses/update.json"
    static let retweetPathPrefix = "1.1/statuses/retweet/"
    static let retweetPathSuffix = ".json"
    static let unretweetPathPrefix = "1.1/statuses/unretweet/"
    static let unretweetPathSuffix = ".json"
    static let favoritePath = "1.1/favorites/create.json"
    static let unfavoritePath = "1.1/favorites/destroy.json"
    
    /*** shared instance of the session manager ***/
    static let sharedInstance:TwitterClient = TwitterClient(baseURL: NSURL(string: baseURLString)!, consumerKey: consumerKey, consumerSecret: consumerSecret)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError!) -> ())?
    
    func login(success: () -> () , failure:(NSError!) -> ()) {
        // save these to be called when necessary
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath(TwitterClient.requestTokenPath, method: "GET", callbackURL: NSURL(string:ext + "://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) in
            // open the url in Safari
            let url = NSURL(string: TwitterClient.authorizeURL + requestToken.token)!
            UIApplication.sharedApplication().openURL(url)
            }, failure: { (error:NSError!) in
                self.loginFailure!(error)
        })
    }
    
    /*** url includes requestToken; fetches accessToken ***/
    func handleOpenURL(url:NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.sharedInstance.fetchAccessTokenWithPath(TwitterClient.accessTokenPath, method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential!) in
                self.currentAccount( { (user: User) -> () in
                    User.currentUser = user
                    self.loginSuccess?()
                }, failure: { (error:NSError) -> () in
                    self.loginFailure?(error)
                })
            }, failure: { (error:NSError!) in
                self.loginFailure?(error)
            }
        )
    }

    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotif, object: nil)
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        TwitterClient.sharedInstance.GET(TwitterClient.verifyPath, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response:AnyObject?) in
                let user = User(dictionary: response as! NSDictionary)
                success(user)
            }, failure: { (task:NSURLSessionDataTask?, error:NSError) in
                failure(error)
            }
        )
    }
    
    func loadUserData(screen_name: String!, success: (User) -> (), failure: (NSError) -> ()) {
        TwitterClient.sharedInstance.GET(TwitterClient.showUserPath, parameters: ["screen_name":screen_name], progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) in
                let user = User(dictionary: response as! NSDictionary)
                success(user)
            }, failure: { (task:NSURLSessionDataTask?, error:NSError) in
                failure(error)
        })
    }
    
    func follow(screenName: String!, success: (() -> ()), failure: ((NSError) -> ()), completion: (() -> ())) {
        let fullSuccess = { (task:NSURLSessionDataTask, response:AnyObject?) in
            success()
            completion()
        }
        let fullFailure = { (task:NSURLSessionDataTask?, error:NSError) in
            failure(error)
            completion()
        }
        print("will follow " + screenName)
        print(TwitterClient.followPath)
        TwitterClient.sharedInstance.POST(TwitterClient.followPath, parameters: ["screen_name":screenName], progress: nil, success: fullSuccess, failure: fullFailure)
    }
    
    func unfollow(screenName: String!, success: (() -> ()), failure: ((NSError) -> ()), completion: (() -> ())) {
        let fullSuccess = { (task:NSURLSessionDataTask, response:AnyObject?) in
            success()
            completion()
        }
        let fullFailure = { (task:NSURLSessionDataTask?, error:NSError) in
            failure(error)
            completion()
        }
        print("will unfollow " + screenName)
        print(TwitterClient.unfollowPath)
        TwitterClient.sharedInstance.POST(TwitterClient.unfollowPath, parameters: ["screen_name":screenName], progress: nil, success: fullSuccess, failure: fullFailure)
    }
    
    func timeline(loadCount:Int, screenName: String?, success: ([Tweet]) -> (), failure:(NSError) -> (), completion: () -> ()) {
        let fullSuccess = { (task:NSURLSessionDataTask, response:AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsFromArray(dictionaries)
            success(tweets)
            completion()
        }
        let fullFailure = { (task:NSURLSessionDataTask?, error:NSError) in
            failure(error)
            completion()
        }
        
        if let screenName = screenName {
            TwitterClient.sharedInstance.GET(TwitterClient.userTimelinePath, parameters: ["screen_name":screenName, "count":loadCount * 20], progress: nil, success: fullSuccess, failure: fullFailure)
        } else {
            TwitterClient.sharedInstance.GET(TwitterClient.homeTimelinePath, parameters: ["count":loadCount * 20], progress: nil, success: fullSuccess, failure: fullFailure)
        }
    }
    
    func tweet(tweet:String!, success: () -> (), failure:(NSError) -> ()) {
        TwitterClient.sharedInstance.POST(TwitterClient.updatePath, parameters: ["status":tweet], progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) in
                    success()
                }, failure: { (task:NSURLSessionDataTask?, error:NSError) in
                    failure(error)
                }
        )
    }
    
    func reply(replyTo: Tweet, tweetText:String!, success: () -> (), failure:(NSError) -> ()) {
        TwitterClient.sharedInstance.POST(TwitterClient.updatePath, parameters: ["status":tweetText, "in_reply_to_status_id":replyTo.id], progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) in
                success()
            }, failure: { (task:NSURLSessionDataTask?, error:NSError) in
                failure(error)
            }
        )
    }

    
    func retweet(id:String!, success: () -> (), failure:(NSError) -> ()) {
        TwitterClient.sharedInstance.POST(TwitterClient.retweetPathPrefix + id + TwitterClient.retweetPathSuffix, parameters: nil, progress:nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) in
                success()
            }, failure: { (task:NSURLSessionDataTask?, error:NSError) in
                failure(error)
            }
        )
    }
    
    func unretweet(id:String!, success: () -> (), failure:(NSError) -> ()) {
        TwitterClient.sharedInstance.POST(TwitterClient.unretweetPathPrefix + id + TwitterClient.unretweetPathSuffix, parameters: nil, progress:nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) in
            success()
            }, failure: { (task:NSURLSessionDataTask?, error:NSError) in
                failure(error)
            }
        )
    }
    
    func favorite(id:String!, success: () -> (), failure:(NSError) -> ()) {
        TwitterClient.sharedInstance.POST(TwitterClient.favoritePath, parameters: ["id":id], progress:nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) in
                success()
            }, failure: { (task:NSURLSessionDataTask?, error:NSError) in
                failure(error)
            }
        )
    }
    
    func unfavorite(id:String!, success: () -> (), failure:(NSError) -> ()) {
        TwitterClient.sharedInstance.POST(TwitterClient.unfavoritePath, parameters: ["id":id], progress:nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) in
                success()
            }, failure: { (task:NSURLSessionDataTask?, error:NSError) in
                failure(error)
            }
        )
    }
}
