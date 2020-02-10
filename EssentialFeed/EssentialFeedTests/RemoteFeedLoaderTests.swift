//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Sachin Sabu on 09/01/20.
//  Copyright © 2020 utilityappstudio. All rights reserved.
//

import XCTest
import EssentialFeed

class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doesnotRequestDataFromURL(){
         let (_,client) = makeSUT()
                XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut,client) = makeSUT(url:url)
        sut.load()
        XCTAssertEqual(client.requestedURLs,[url])
    }
    func test_loadTwice_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut,client) = makeSUT(url:url)
        sut.load()
        sut.load()
        XCTAssertEqual(client.requestedURLs, [url,url])
    }
    func test_load_DeliversErrorOnClientError() {
        let (sut,client) = makeSUT()
        client.error = NSError(domain: "Test", code: 0)
        var capturedError = [RemoteFeedLoader.Error]()
        sut.load {
            capturedError.append($0)
        }
        XCTAssertEqual(capturedError, [.connectiviy])
    }
    // MARK: - Helpers
    private func makeSUT(url:URL =  URL(string: "https://a-url.com")!) ->  (sut:RemoteFeedLoader, client:HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut,client)
    }
    private class HTTPClientSpy:HTTPClient {
        var requestedURLs = [URL]()
        var error:Error?
        func get(from url:URL, completion:@escaping (Error)-> Void ) {
            if let error = error {
                completion(error)
            }
            requestedURLs.append(url)
        }
    }
}
