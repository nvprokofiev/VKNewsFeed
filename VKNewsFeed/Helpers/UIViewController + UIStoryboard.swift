//
//  UIViewController + UIStoryboard.swift
//  VKNewsFeed
//
//  Created by Nikolai Prokofev on 2019-07-08.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    class func loadFromSroryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let vc = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()
        guard let instantiatedVC = vc as? T else {
            fatalError("unable to instatiate view controller \(name) from storyboard")
        }
        
        return instantiatedVC
    }
}
