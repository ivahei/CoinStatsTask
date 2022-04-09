//
//  MainTableViewController.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 07.04.22.
//

import UIKit

import RealmSwift

final class MainTableViewController: UITableViewController {

    let networkController = NetworkController.shared

    var articles: [Article] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()

        if UIDevice.current.userInterfaceIdiom == .pad {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
            showSplitViewDetails(for: indexPath)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
}

// MARK: - TableView

extension MainTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "MainCell",
                for: indexPath
            ) as? MainTableViewCell else { fatalError() }

        cell.populate(with: articles[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        articles[indexPath.row].isRead = true

        if UIDevice.current.userInterfaceIdiom == .pad {
            let currentIndexPath = IndexPath(row: indexPath.row, section: 0)
            tableView.reloadRows(at: [currentIndexPath], with: .none)
        }

        showSplitViewDetails(for: indexPath)
    }

    private func showSplitViewDetails(for indexPath: IndexPath) {
        guard let detailsViewController = storyboard?
            .instantiateViewController(
                withIdentifier: "DetailViewController"
            ) as?
                DetailViewController
        else { fatalError() }

        detailsViewController.article = articles[indexPath.row]
        splitViewController?.showDetailViewController(detailsViewController, sender: self)
    }
}
