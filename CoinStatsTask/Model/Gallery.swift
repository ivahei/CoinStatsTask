//
//  Gallery.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 11.04.22.
//

import Foundation

struct Gallery: Decodable, Hashable {
    var title: String
    var contentUrl: String
    var thumbnailUrl: String
}
