//
//  GalleryRealm.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 11.04.22.
//

import Foundation

import RealmSwift

class GalleryRealm: Object {
    @Persisted var title: String = ""
    @Persisted var contentUrl: String = ""
    @Persisted var thumbnailUrl: String = ""
}
