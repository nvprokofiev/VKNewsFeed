//
//  FeedCellLayoutCalculator.swift
//  VKNewsFeed
//
//  Created by Nikolai Prokofev on 2019-07-18.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import Foundation
import UIKit

protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttachment: FeedCellPhotoAttachmentViewModel?, isRevealed: Bool)-> FeedCellSizes
}

struct Sizes: FeedCellSizes {
    var postLabelFrame: CGRect
    var attachmentFrame: CGRect
    var bottomViewFrame: CGRect
    var showMoreButtonFrame: CGRect
    var totalHeight: CGFloat
}

final class FeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    
    private struct Constants {
        static let cardViewEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 12, right: 8)
        static let postLabelEdgeInsets = UIEdgeInsets(top: Constants.topViewHeight + 16,
                                                      left: Constants.cardViewEdgeInsets.left,
                                                      bottom: 8,
                                                      right: 8)

        static let postLabelFont = UIFont.systemFont(ofSize: 15)
        static let topViewHeight: CGFloat = 36
        static let bottomViewHeight: CGFloat = 44
        static let showMoreButtonHeight: CGFloat = 16
    }
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, photoAttachment: FeedCellPhotoAttachmentViewModel?, isRevealed: Bool)-> FeedCellSizes {
        let cardWidth = screenWidth - Constants.cardViewEdgeInsets.left - Constants.cardViewEdgeInsets.right
        let postLabelWidth = cardWidth - Constants.postLabelEdgeInsets.left - Constants.postLabelEdgeInsets.right
        
        var postLabelFrame = CGRect(origin: CGPoint(x: Constants.postLabelEdgeInsets.left,
                                                    y: Constants.postLabelEdgeInsets.top),
                                    size: .zero)
        
        var showMoreButtonFrame = CGRect.zero
        
        if let text = postText, !text.isEmpty {
            postLabelFrame.size =  CGSize(width: postLabelWidth,
                                          height: text.height(width: postLabelWidth, font: Constants.postLabelFont))
            
            if postLabelFrame.height > 100 && !isRevealed {
                
                postLabelFrame.size = CGSize(width: postLabelFrame.width, height: 100)

                showMoreButtonFrame = CGRect(origin: CGPoint(x: postLabelFrame.minX, y: postLabelFrame.maxY + 4),
                                             size: CGSize(width: postLabelFrame.width, height: Constants.showMoreButtonHeight))
            }
        }
        
        var attachmentTop = postLabelFrame.size == .zero  ? postLabelFrame.minY : postLabelFrame.maxY + Constants.postLabelEdgeInsets.bottom

        if showMoreButtonFrame != .zero {
            attachmentTop = showMoreButtonFrame.maxY + Constants.postLabelEdgeInsets.bottom
        }
        
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmentTop), size: .zero)

        if let attchment = photoAttachment {
            
            let attachmentWidth = CGFloat(attchment.width)
            let attachmentHeight = CGFloat(attchment.height)

            let ratio =  attachmentHeight / attachmentWidth
        
            attachmentFrame.size = CGSize(width: cardWidth, height: cardWidth * ratio)
        }
        
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: max(postLabelFrame.maxY, attachmentFrame.maxY)), size: CGSize(width: cardWidth, height: Constants.bottomViewHeight))
        
        return Sizes(postLabelFrame: postLabelFrame,
                     attachmentFrame: attachmentFrame,
                     bottomViewFrame: bottomViewFrame,
                     showMoreButtonFrame: showMoreButtonFrame,
                     totalHeight: bottomViewFrame.maxY + Constants.cardViewEdgeInsets.bottom)
    }
}

