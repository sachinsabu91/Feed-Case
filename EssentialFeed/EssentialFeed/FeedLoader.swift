//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Sachin Sabu on 07/01/20.
//  Copyright © 2020 utilityappstudio. All rights reserved.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}
protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
