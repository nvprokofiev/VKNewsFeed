//
//  NewsFeedInteractor.swift
//  VKNewsFeed
//
//  Created by Nikolai Prokofev on 2019-07-11.
//  Copyright (c) 2019 Nikolai Prokofev. All rights reserved.
//

import UIKit

protocol NewsFeedBusinessLogic {
  func makeRequest(request: NewsFeed.Model.Request.RequestType)
}

class NewsFeedInteractor: NewsFeedBusinessLogic {

  var presenter: NewsFeedPresentationLogic?
  var service: NewsFeedService?
private var fetcher: DataFetcher = NetworkDataFetcher(network: NetworkService())
    
    private var feedResponse: FeedResponse?
    private var revealedPosts: [Int] = []
  
  func makeRequest(request: NewsFeed.Model.Request.RequestType) {
    if service == nil {
      service = NewsFeedService()
    }
    switch request {
        case .getNewsFeed:
        fetcher.getFeed { [weak self] response in

            guard let feedReponse = response else { return }
            self?.feedResponse = feedReponse
            self?.presentFeed()

        }
    case .revealPost(let id):
        revealedPosts.append(id)
        presentFeed()
    }
  }
    
    private func presentFeed() {
        guard let feedReponse = self.feedResponse else { return }
        presenter?.presentData(response: .presentFeed(feed: feedReponse, revealedPosts: revealedPosts))
    }
  
}
