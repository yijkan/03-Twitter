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
    static let homeTimelinePath = "1.1/statuses/home_timeline.json"
    
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
    
    func homeTimeline(success: ([Tweet]) -> (), failure:(NSError) -> ()) {
        TwitterClient.sharedInstance.GET(TwitterClient.homeTimelinePath, parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, response:AnyObject?) in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsFromArray(dictionaries)
                success(tweets)
            }, failure: { (task:NSURLSessionDataTask?, error:NSError) in
                failure(error)
            }
        )
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
                    }
                )
            }, failure: { (error:NSError!) in
                self.loginFailure?(error)
            }
 
        )
    }
}
