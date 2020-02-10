//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Sachin Sabu on 13/01/20.
//  Copyright © 2020 utilityappstudio. All rights reserved.
//

import Foundation

public protocol HTTPClient {
    func get(from url:URL, completion:@escaping (Error)-> Void )
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client:HTTPClient
    public enum Error: Swift.Error {
        case connectiviy
    }
   public init(url:URL, client:HTTPClient) {
        self.url = url
        self.client = client
    }
    public func load(completion:@escaping (Error)-> Void) {
        client.get(from :url){
            error in
            completion(.connectiviy)
        }
    }
}
