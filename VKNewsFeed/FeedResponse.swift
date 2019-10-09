//
//  FeedResponse.swift
//  VKNewsFeed
//
//  Created by Nikolai Prokofev on 2019-07-10.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import Foundation

struct FeedResponseWrapped: Decodable {
    let response: FeedResponse
}

struct FeedResponse: Decodable {
    var items: [FeedItem]
}

struct FeedItem: Decodable {
    let sourceId: Int
    let postId: Int
    let text: String?
    let date: Double
    let comments: CountableItem?
    let likes: CountableItem?
    let views: CountableItem?
    let reposts: CountableItem?
}

struct CountableItem: Decodable {
    let count: Int
}
