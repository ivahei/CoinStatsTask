//
//  PersistenceController.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 10.04.22.
//

import UIKit

import RealmSwift

final class PersistenceController {

    // MARK: - Singleton

    static let shared = PersistenceController()
    private init() {}

    let networkController = NetworkController.shared

    func writeInRealm(_ articles: [Article], modify: Bool) {
        do {
            let realm = try Realm()
            try realm.write {
                articles.forEach {
                    let articleRealm = ArticleRealm()
                    let galleryRealm = List<GalleryRealm>()
                    if let gallery = $0.gallery {
                        gallery.forEach {
                            let galleryItemRealm = GalleryRealm()
                            galleryItemRealm.title = $0.title
                            galleryItemRealm.thumbnailUrl = String($0.thumbnailUrl)
                            galleryItemRealm.contentUrl = String($0.contentUrl)

                            galleryRealm.append(galleryItemRealm)
                        }
                    }
                    articleRealm.id = "\($0.date.timeIntervalSince1970)"
                    articleRealm.title = $0.title
                    articleRealm.category = $0.category
                    articleRealm.body = $0.body
                    articleRealm.date = $0.date
                    articleRealm.coverPhotoUrl = "\($0.coverPhotoUrl)"
                    articleRealm.isRead = $0.isRead ?? false
                    articleRealm.gallery = galleryRealm

                    if modify {
                        realm.add(articleRealm, update: .modified)
                    } else if realm.object(ofType: ArticleRealm.self, forPrimaryKey: articleRealm.id) == nil {
                        realm.add(articleRealm)
                    }
                }
            }
        } catch {
            print("Error initialising new realm, \(error)")
        }
    }

    func readArticles() -> [Article] {
        var articles = [Article]()
        do {
            let realm = try Realm()

            let realmArticle = Array(realm.objects(ArticleRealm.self))
            realmArticle.forEach {
                let realmGallery = Array($0.gallery)
                var gallery = [Gallery]()
                realmGallery.forEach {
                    let galleryItem = Gallery(
                        title: $0.title,
                        contentUrl: $0.contentUrl,
                        thumbnailUrl: $0.thumbnailUrl
                    )
                    gallery.append(galleryItem)
                }

                let article = Article(
                    title: $0.title,
                    category: $0.category,
                    date: $0.date,
                    coverPhotoUrl: $0.coverPhotoUrl,
                    body: $0.body,
                    gallery: gallery,
                    isRead: $0.isRead
                )
                articles.append(article)
            }
        } catch {
            print("Error initialising new realm, \(error)")
        }
        return articles
    }
}
