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
    var title: String
    var category: String
    var date: Date
    var coverPhotoUrl: URL
    var body: String
    var gallery: [Gallery]?
    var isRed: Bool?
}

struct Gallery: Decodable {
    var title: String
    var contentUrl: URL
}
