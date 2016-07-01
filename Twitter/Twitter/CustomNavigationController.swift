//
//  CustomNavigationController.swift
//  Twitter
//
//  Created by Yijin Kang on 7/1/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    @IBOutlet weak var customTabBarItem: UITabBarItem!
    
    override func viewDidLoad() {
        customTabBarItem.setTitleTextAttributes([NSFontAttributeName : labelFont(10)], forState: .Normal)
    }

}
