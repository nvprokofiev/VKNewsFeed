//
//  NewsFeedPresenter.swift
//  VKNewsFeed
//
//  Created by Nikolai Prokofev on 2019-07-11.
//  Copyright (c) 2019 Nikolai Prokofev. All rights reserved.
//

import UIKit

protocol NewsFeedPresentationLogic {
  func presentData(response: NewsFeed.Model.Response.ResponseType)
}

class NewsFeedPresenter: NewsFeedPresentationLogic {

    weak var viewController: NewsFeedDisplayLogic?
    var feedLayoutCalculator: FeedCellLayoutCalculatorProtocol = FeedCellLayoutCalculator()
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMM 'в' HH:mm"
        return dateFormatter
    }()
  
    func presentData(response: NewsFeed.Model.Response.ResponseType) {
        switch response {
        case .presentFeed(let feed, let revealedPosts):
        
            let cells = feed.items.map { cellViewModel(feedItem: $0, profiles: feed.profiles, groups: feed.groups, reveledPosts: revealedPosts)}
            let feedViewModel = FeedViewModel(cells: cells)
            viewController?.displayData(viewModel: .displayFeed(feedViewModel: feedViewModel))
        }
    }
    
    private func cellViewModel(feedItem: FeedItem, profiles: [Profile], groups: [Group], reveledPosts: [Int]) -> FeedViewModel.Cell {
        
        let profile: ProfileRepresentable? = getProfile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: feedItem.date))
        let photoAttachment = getPhotoAttachment(feedItem: feedItem)
        
        let isRevealed = reveledPosts.contains(where: {$0 == feedItem.postId })
        
        let sizes = feedLayoutCalculator.sizes(postText: feedItem.text, photoAttachment: photoAttachment, isRevealed: isRevealed)
        
        return FeedViewModel.Cell(postId: feedItem.postId, iconUrlString: profile?.photo ?? "",
                                  name: profile?.name ?? "",
                                  date: dateString,
                                  text: feedItem.text,
                                  likes: String(feedItem.likes?.count ?? 0),
                                  comments: String(feedItem.comments?.count ?? 0),
                                  reposts: String(feedItem.reposts?.count ?? 0),
                                  views: String(feedItem.views?.count ?? 0),
                                  photoAttachment: photoAttachment,
                                  sizes: sizes)
    }
    
    private func getProfile(for id: Int, profiles: [Profile], groups: [Group])-> ProfileRepresentable? {
        let sources: [ProfileRepresentable] = id >= 0 ? profiles : groups
        return sources.first(where: { $0.id == abs(id) })
    }
    
    private func getPhotoAttachment(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttachment? {
        
        guard let photo = feedItem.attachments?.compactMap({ $0.photo }).first else { return nil }
        
        let photoAttachment = FeedViewModel.FeedCellPhotoAttachment(photoUrlString: photo.url, width: photo.width, height: photo.height)
        
        return photoAttachment
    }
}
