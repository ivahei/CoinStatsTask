//
//  ArticleRealm.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 08.04.22.
//

import Foundation

import RealmSwift

class ArticleRealm: Object {
    @Persisted var id: String = ""
    @Persisted var title: String = ""
    @Persisted var category: String = ""
    @Persisted var date: Date = Date()
    @Persisted var coverPhotoUrl: String = ""
    @Persisted var body: String = ""
    @Persisted var isRead: Bool = false
    @Persisted var gallery: List<GalleryRealm> = List<GalleryRealm>()

    override static func primaryKey() -> String {
            return "id"
        }
}
