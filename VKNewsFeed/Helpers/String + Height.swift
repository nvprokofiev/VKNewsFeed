//
//  String + Height.swift
//  VKNewsFeed
//
//  Created by Nikolai Prokofev on 2019-08-06.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        if self.isEmpty {
            return 0.0
        }
        
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let rect = self.boundingRect(with: textSize,
                                       options: .usesLineFragmentOrigin,
                                       attributes: [NSAttributedString.Key.font : font],
                                       context: nil)
        
        return rect.height

    }
}
