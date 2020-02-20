//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Sachin Sabu on 13/01/20.
//  Copyright © 2020 utilityappstudio. All rights reserved.
//

import Foundation

public enum HTTPClientResult {
    case success(Data,HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url:URL, completion: @escaping (HTTPClientResult) -> Void )
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client:HTTPClient
    public enum Error: Swift.Error {
        case connectiviy
        case invalidData
    }
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
   public init(url:URL, client:HTTPClient) {
        self.url = url
        self.client = client
    }
    public func load(completion:@escaping (Result)-> Void) {
        client.get(from :url){
            result in
            switch result {
            case .success:
                completion(.failure(.invalidData))
            case .failure:
                completion(.failure(.connectiviy))
            }
        }
    }
}
