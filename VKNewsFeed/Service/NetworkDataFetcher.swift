//
//  NetworkDataFetcher.swift
//  VKNewsFeed
//
//  Created by Nikolai Prokofev on 2019-07-10.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func getFeed(response: @escaping (FeedResponse?)->Void)
}

struct NetworkDataFetcher: DataFetcher {
    
    let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    
    func getFeed(response: @escaping (FeedResponse?) -> Void) {
        let params = ["filters": "post,photo"]
        
        network.request(path: API.newsFeed, params: params) { data, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            let decoded = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from data: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = data, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
    
}
