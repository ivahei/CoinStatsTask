//
//  LaunchViewController.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 09.04.22.
//

import UIKit

class LaunchViewController: UIViewController {

    let networkController = NetworkController.shared
    let persistenceController = PersistenceController.shared

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchArticles()
    }

    private func fetchArticles() {
        let articles = persistenceController.readArticles()
        networkController.fetchItems { [weak self] result in
            guard let self = self else { fatalError() }
            if !articles.isEmpty {
            self.sendArticlesToMainVC(articles)
            }
            switch result {
            case .success(let articles):
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

                    self.persistenceController.writeInRealm(articles, modify: false)
                    mainTableViewController.articles = self.persistenceController.readArticles()
                    if self.articles.isEmpty {
                        splitViewController.delegate = UIApplication.shared.delegate as? AppDelegate
                        UIApplication.shared.windows.first?.rootViewController = splitViewController
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
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

            mainTableViewController.articles = self.persistenceController.readArticles()
            splitViewController.delegate = UIApplication.shared.delegate as? AppDelegate
            UIApplication.shared.windows.first?.rootViewController = splitViewController
        }
    }

    // MARK: - Injection

    var articles: [Article] = []
}
