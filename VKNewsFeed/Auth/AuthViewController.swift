//
//  AuthViewController.swift
//  VKNewsFeed
//
//  Created by Nikolai Prokofev on 2019-07-08.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    private var authService: AuthService!

    override func viewDidLoad() {
        super.viewDidLoad()
        authService = AppDelegate.shared().authService
        

    }

    @IBAction func loginTapped(_ sender: Any) {
        authService.wakeUpSession()
    }
}
