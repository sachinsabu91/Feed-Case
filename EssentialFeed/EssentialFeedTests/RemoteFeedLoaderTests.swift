//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Sachin Sabu on 09/01/20.
//  Copyright © 2020 utilityappstudio. All rights reserved.
//

import XCTest
class RemoteFeedLoader {
    let client:HTTPClient
    let url: URL
    init(url:URL, client:HTTPClient) {
        self.url = url
        self.client = client
    }
    func load() {
        client.get(from :url)
    }
}
protocol HTTPClient {
    func get(from url:URL)
}
class HTTPClientSpy:HTTPClient {
     func get(from url:URL) {
           requestedURL = url
       }
       var requestedURL: URL?
}
class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesnotRequestDataFromURL(){
        let url =  URL(string: "https://a-url.com")!
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(url:url, client:client)
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_RequestDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url:url,client:client)
        sut.load()
        XCTAssertEqual(client.requestedURL,url)
    }
}
