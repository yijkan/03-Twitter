//
//  Url.swift
//  Twitter
//
//  Created by Yijin Kang on 6/30/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import Foundation

class Url {
    var indices: (Int, Int)?
    var URL: String?
    var displayURL: String?
    var expandedURL: String?
    
    init (dict: NSDictionary) {
        if let indicesArray = dict["indices"] as? NSArray {
            if let startIndex = indicesArray[0] as?  Int {
                if let endIndex = indicesArray[1] as? Int {
                    indices = (startIndex, endIndex)
                }
            }
        }

        URL = dict["url"] as? String
        displayURL = dict["display_url"] as? String
        expandedURL = dict["expanded_url"] as? String
    }
    
    class func dicts2URLs(dicts: [NSDictionary]) -> [Url] {
        var urls: [Url] = []
        for dict in dicts {
            urls.append(Url(dict: dict))
        }
        return urls
    }
    
}