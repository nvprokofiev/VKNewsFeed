//
//  NetworkService.swift
//  VKNewsFeed
//
//  Created by Nikolai Prokofev on 2019-07-10.
//  Copyright © 2019 Nikolai Prokofev. All rights reserved.
//

import Foundation
import UIKit

protocol Networking {
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?)-> Void)
}

final class NetworkService: Networking {
    
    private var authService: AuthService
    
    init(authService: AuthService = AppDelegate.shared().authService) {
        self.authService = authService
    }
    
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> Void) {
        guard let token = authService.token else { return }
        
        let params = params
        
        var allParams = params
        allParams["v"] = API.version
        allParams["access_token"] = token
        
        let url = self.url(from: path, params: allParams)
        print(url)
        let request = URLRequest(url: url)
        let task = createDataTaks(from: request, completion: completion)
        task.resume()
    }
    
    private func url(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = API.newsFeed
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        
        return components.url!
    }

    private func createDataTaks(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
