//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Sachin Sabu on 07/01/20.
//  Copyright © 2020 utilityappstudio. All rights reserved.
//

import Foundation
public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageUrl: URL
}
