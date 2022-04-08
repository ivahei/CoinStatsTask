//
//  GlobalSplitViewController.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 08.04.22.
//

import UIKit

final class GlobalSplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
}

extension GlobalSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        return true
    }
}
