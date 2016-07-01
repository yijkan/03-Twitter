//
//  SelfViewController.swift
//  Twitter
//
//  Created by Yijin Kang on 6/29/16.
//  Copyright © 2016 Yijin Kang. All rights reserved.
//

import UIKit

class SelfViewController: ProfileViewController {
    override func viewDidLoad() {
        user = User.currentUser
        super.viewDidLoad()
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        super.prepareForSegue(segue, sender: sender)
//    }
}

