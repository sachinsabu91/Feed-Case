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
        sut.load { _ in }
        XCTAssertEqual(client.requestedURLs,[url])
    }
    func test_loadTwice_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut,client) = makeSUT(url:url)
        sut.load { _ in }
        sut.load { _ in }
        XCTAssertEqual(client.requestedURLs, [url,url])
    }
    func test_load_DeliversErrorOnClientError() {
        let (sut,client) = makeSUT()
       expect(sut, tocompleteWithError: .connectiviy, when: {
         let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        })
    }
    func test_load_DeliversErrorOnNon200HTTPResponse() {
        let (sut,client) = makeSUT()
        let samples =   [199,201,300,400,500]
        samples.enumerated().forEach {
            index, code in
            expect(sut, tocompleteWithError: .invalidData, when: {
                client.complete(withStatusCode: code, at: index)
            })
        }
        
    }
    func test_load_DeliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut,client) = makeSUT()
        expect(sut, tocompleteWithError: .invalidData, when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200,data:invalidJSON)
        })
        
    }
    // MARK: - Helpers
    private func makeSUT(url:URL =  URL(string: "https://a-url.com")!) ->  (sut:RemoteFeedLoader, client:HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut,client)
    }
    private func expect(_ sut: RemoteFeedLoader, tocompleteWithError error:RemoteFeedLoader.Error, when action:()-> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load {
            capturedResults.append($0)
        }
        action()
        XCTAssertEqual(capturedResults, [.failure(error)], file:file, line: line)
    }
    private class HTTPClientSpy:HTTPClient {
      
        private var messages = [(url:URL,completion:(HTTPClientResult)-> Void )]()
        var requestedURLs : [URL] {
            return messages.map {
                $0.url
            }
        }
        
        func get(from url:URL, completion:@escaping (HTTPClientResult)-> Void ) {
            messages.append((url,completion))
        }
        func complete(with error:Error, at index:Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code:Int,data:Data = Data(), at index:Int = 0) {
                let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success(data, response))
              }
        
    }
}
