//
//  AppDelegate.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    /*** called when app is opened after authorization from Safari ***/
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        TwitterClient.sharedInstance.handleOpenURL(url)
        return true
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        if let currentUser = User.currentUser {
            currentUser.reload({ (user) in
                    User.currentUser = user
                }, failure: failureClosure
            )
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("MainTabBar")
            window?.rootViewController = vc
        } 
        
        NSNotificationCenter.defaultCenter().addObserverForName(User.userDidLogoutNotif, object: nil, queue: NSOperationQueue.mainQueue()) { (notification: NSNotification) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = vc
        }
        
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: boldFont(18)]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: labelFont(16)], forState: UIControlState.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: labelFont(10)], forState: UIControlState.Normal)
        self.window!.tintColor = tintColor
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

