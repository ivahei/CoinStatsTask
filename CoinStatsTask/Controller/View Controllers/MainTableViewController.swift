//
//  MainTableViewController.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 07.04.22.
//

import UIKit

import RealmSwift

final class MainTableViewController: UITableViewController {

    let persistenceController = PersistenceController.shared

    var articles: [Article] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()

        markIsReadIfDeviceIsIPad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    private func markIsReadIfDeviceIsIPad() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
            articles[indexPath.row].isRead = true
            persistenceController.writeInRealm(articles)
            showSplitViewDetails(for: indexPath)
        }
    }
}

// MARK: - TableView

extension MainTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { articles.count }

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
        persistenceController.writeInRealm(articles)

        if UIDevice.current.userInterfaceIdiom == .pad {
            let currentIndexPath = IndexPath(row: indexPath.row, section: 0)
            tableView.reloadRows(at: [currentIndexPath], with: .none)
        }

        showSplitViewDetails(for: indexPath)
    }

    private func showSplitViewDetails(for indexPath: IndexPath) {
        let detailsViewController = DetailViewController.getInstance(from: UIStoryboard.main)
        detailsViewController.article = articles[indexPath.row]
        splitViewController?.showDetailViewController(detailsViewController, sender: self)
    }
}
