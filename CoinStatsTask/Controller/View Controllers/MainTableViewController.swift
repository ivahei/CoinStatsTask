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
    var notificationToken: NotificationToken?

    var articles: [Article] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()

        realmChangeListener()
        markIsReadIfDeviceIsIPad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    private func realmChangeListener() {
        do {
            let realm = try Realm()
            let results = realm.objects(ArticleRealm.self)
            notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    tableView.performBatchUpdates({
                        tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }),
                                             with: .automatic)
                        tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                             with: .automatic)
                        tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                             with: .automatic)
                    })
                case .error(let error):
                    fatalError("\(error)")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    private func markIsReadIfDeviceIsIPad() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
            articles[indexPath.row].isRead = true
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
        persistenceController.writeInRealm(articles, modify: true)
        showSplitViewDetails(for: indexPath)
    }

    private func showSplitViewDetails(for indexPath: IndexPath) {
        let detailsViewController = DetailViewController.getInstance(from: UIStoryboard.main)
        detailsViewController.article = articles[indexPath.row]
        splitViewController?.showDetailViewController(detailsViewController, sender: self)
    }
}
