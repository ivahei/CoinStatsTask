//
//  LaunchViewController.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 09.04.22.
//

import UIKit

class LaunchViewController: UIViewController {

    // MARK: - Singleton

    let networkController = NetworkController.shared
    let persistenceController = PersistenceController.shared

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        persistenceController.fetchArticles()
    }

    // MARK: - Injection

    var articles: [Article] = []
}
