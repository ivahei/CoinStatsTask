//
//  LaunchViewController.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 09.04.22.
//

import UIKit

class LaunchViewController: UIViewController {

    let networkController = NetworkController.shared
    var articles: [Article] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        loadArticles()
    }

    // MARK: - Callbacks

    private func loadArticles() {
        networkController.fetchItems { [weak self] result in
            guard let self = self else { fatalError() }

            switch result {
            case .success(let articles):
                DispatchQueue.main.async {
                    guard
                        let splitViewController = self.storyboard?
                        .instantiateViewController(
                            withIdentifier: "SplitViewController"
                        ) as? UISplitViewController,
                        let navigationController = splitViewController.viewControllers.first
                            as? UINavigationController,
                        let mainTableViewController = navigationController.visibleViewController
                            as? MainTableViewController
                    else { fatalError() }

                    mainTableViewController.articles = articles
                    splitViewController.delegate = UIApplication.shared.delegate as? AppDelegate
                    self.view.window?.rootViewController = splitViewController
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
