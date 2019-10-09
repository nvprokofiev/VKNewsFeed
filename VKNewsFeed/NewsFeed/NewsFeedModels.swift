//
//  NewsFeedModels.swift
//  VKNewsFeed
//
//  Created by Nikolai Prokofev on 2019-07-11.
//  Copyright (c) 2019 Nikolai Prokofev. All rights reserved.
//

import UIKit

enum NewsFeed {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getNewsFeed
        case revealPost(id: Int)
      }
    }
    struct Response {
      enum ResponseType {
        case presentFeed(feed: FeedResponse, revealedPosts: [Int])
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayFeed(feedViewModel: FeedViewModel)
      }
    }
  }
  
}

struct FeedViewModel {
    
    struct Cell: FeedCellViewModel {
        var postId: Int
        var iconUrlString: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var reposts: String?
        var views: String?
        var photoAttachment: FeedCellPhotoAttachmentViewModel?
        var sizes: FeedCellSizes
    }
    
    struct FeedCellPhotoAttachment: FeedCellPhotoAttachmentViewModel {
        var photoUrlString: String
        var width: Int
        var height: Int
    }
    
    let cells: [Cell]
}
