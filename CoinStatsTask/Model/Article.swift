//
//  Content.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 07.04.22.
//

import Foundation

struct ArticleResponse: Decodable {
    let data: [Article]
}

struct Article: Decodable {
    var id: String?
    var title: String
    var category: String
    var date: Date
    var coverPhotoUrl: String
    var body: String
    var gallery: [Gallery]?
    var isRead: Bool?
}

struct Gallery: Decodable, Hashable {
    var title: String
    var contentUrl: String
    var thumbnailUrl: String
}
