//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Sachin Sabu on 09/01/20.
//  Copyright © 2020 utilityappstudio. All rights reserved.
//

import XCTest
class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.get(from :URL(string: "https://a-url.com")!)
    }
}
class HTTPClient {
    static var shared = HTTPClient()
    func get(from url:URL) {}
}
class HTTPClientSpy:HTTPClient {
    override func get(from url:URL) {
           requestedURL = url
       }
       var requestedURL: URL?
}
class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesnotRequestDataFromURL(){
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_RequestDataFromURL() {
        let client = HTTPClientSpy()
        HTTPClient.shared = client
        let sut = RemoteFeedLoader()
        sut.load()
        XCTAssertNotNil(client.requestedURL)
    }
}
