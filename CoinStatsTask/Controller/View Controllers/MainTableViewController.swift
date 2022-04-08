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
    var articles: [Article]?
    var selectedArticle: Article!
    var selectedImage: UIImage!

//    let realm = try? Realm()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            do {
                articles = try await networkController.fetchItems()
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { tableView.reloadData() }
    }
}

// MARK: - Table view methods

extension MainTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "MainCell",
                for: indexPath
            ) as? MainTableViewCell else { fatalError() }

        if let model = articles {
            cell.populate(with: model[indexPath.row])
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        articles?[indexPath.row].isRed = true
        selectedArticle = articles?[indexPath.row]
        performSegue(withIdentifier: "presentDetailVC", sender: self)
    }
}

// MARK: - Segway Actions

extension MainTableViewController {
    @IBSegueAction
    func presentDetailVC(
        _ coder: NSCoder,
        sender: Any?,
        segueIdentifier: String?
    ) -> DetailViewController? {
        DetailViewController(
            coder: coder,
            article: selectedArticle
        )
    }
}
