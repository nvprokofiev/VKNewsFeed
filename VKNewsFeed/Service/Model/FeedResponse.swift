//
//  FeedResponse.swift
//  VKNewsFeed
//
//  Created by Nikolai Prokofev on 2019-07-11.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import Foundation
import UIKit

struct FeedResponseWrapped: Decodable {
    var response: FeedResponse
}

struct FeedResponse: Decodable {
    var items: [FeedItem]
    var profiles: [Profile]
    var groups: [Group]
}

struct FeedItem: Decodable {
    let sourceId: Int
    let date: Double
    let postId: Int
    let text: String?
    let likes: CountableObject?
    let reposts: CountableObject?
    let comments: CountableObject?
    let views: CountableObject?
    
    let attachments: [Attachment]?
}

struct CountableObject: Decodable {
    var count: Int
}

protocol ProfileRepresentable {
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
}

struct Profile: Decodable, ProfileRepresentable {
    
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    
    var photo: String {
        return photo100
    }
    var name: String {
        return firstName + " " + lastName
    }

}

struct Group: Decodable, ProfileRepresentable {
    
    let id: Int
    let name: String
    let photo100: String
    
    var photo: String {
        return photo100
    }
}

struct Attachment: Decodable {
    let photo: Photo?
}

struct Photo: Decodable {
    let sizes: [PhotoSize]
    
    var height: Int {
        return getProperSize().height
    }
    
    var width: Int {
        return getProperSize().width
    }
    
    var url: String {
        return getProperSize().url
    }
    
    private func getProperSize()-> PhotoSize {
        if let sizeX = sizes.first(where: { $0.type == "x" }) {
            return sizeX
        } else if let sizeLast = sizes.last {
            return sizeLast
        } else {
            return PhotoSize(url: "", width: 0, height: 0, type: "")
        }
    }
}

struct PhotoSize: Decodable {
    let url: String
    let width: Int
    let height: Int
    let type: String
}

