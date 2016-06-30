//
//  util.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

let ext = "mytweet"

// the following is by referencing:
// http://stackoverflow.com/questions/27310883/swift-ios-doesrelativedateformatting-have-different-values-besides-today-and
// https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSCalendar_Class/#//apple_ref/occ/instm/NSCalendar/components:fromDate:toDate:options:

extension NSDate {
    func yearsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year ?? 0
    }
    func monthsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month ?? 0
    }
    func weeksFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear ?? 0
    }
    func daysFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day ?? 0
    }
    func hoursFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour ?? 0
    }
    func minutesFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute ?? 0
    }
    func secondsFrom(date: NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second ?? 0
    }
    var relativeTime: String {
        let now = NSDate()
        if now.yearsFrom(self)   > 0 {
            return now.yearsFrom(self).description  + "y"
        }
        if now.monthsFrom(self)  > 0 {
            return now.monthsFrom(self).description + "mo"
        }
        if now.weeksFrom(self)   > 0 {
            return now.weeksFrom(self).description  + "w"
        }
        if now.daysFrom(self)    > 0 {
            return now.daysFrom(self).description + "d"
        }
        if now.hoursFrom(self)   > 0 {
            return "\(now.hoursFrom(self))h"
        }
        if now.minutesFrom(self) > 0 {
            return "\(now.minutesFrom(self))m"
        }
        if now.secondsFrom(self) >= 0 {
            if now.secondsFrom(self) < 5 { return "now"  }
            return "\(now.secondsFrom(self))s"
        }
        return ""
    }
}