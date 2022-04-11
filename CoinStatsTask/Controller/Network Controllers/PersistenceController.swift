//
//  PersistenceController.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 10.04.22.
//

import UIKit

import RealmSwift

final class PersistenceController {

    static let shared = PersistenceController()
    private init() {}

    let networkController = NetworkController.shared

    func fetchArticles() {
        let articles = readArticles()
        if articles.isEmpty {
            networkController.fetchItems { [weak self] result in
                guard let self = self else { fatalError() }

                switch result {
                case .success(let articles):
                    self.sendArticlesToMainVC(articles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            sendArticlesToMainVC(articles)
        }
    }

    private func sendArticlesToMainVC(_ articles: [Article]) {
        DispatchQueue.main.async {
            guard
                let splitViewController = UIStoryboard.main
                    .instantiateViewController(
                        withIdentifier: "SplitViewController"
                    ) as? UISplitViewController,
                let navigationController = splitViewController
                    .viewControllers.first as? UINavigationController,
                let mainTableViewController = navigationController
                    .visibleViewController as? MainTableViewController
            else { fatalError("Initialization issue") }
            self.writeInRealm(articles)
            mainTableViewController.articles = self.readArticles()
            splitViewController.delegate = UIApplication.shared.delegate as? AppDelegate
            UIApplication.shared.windows.first?.rootViewController = splitViewController
        }
    }

    func writeInRealm(_ articles: [Article]) {
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

                    realm.add(articleRealm, update: .modified)
                }
            }
        } catch {
            print("Error initialising new realm, \(error)")
        }
    }

    private func readArticles() -> [Article] {
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
