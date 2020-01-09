//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Sachin Sabu on 09/01/20.
//  Copyright © 2020 utilityappstudio. All rights reserved.
//

import XCTest
class RemoteFeedLoader {
    
}
class HTTPClient {
    var requestedURL: URL?
}
class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesnotRequestDataFromURL(){
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}
