//
//  DetailViewController.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 07.04.22.
//

import UIKit

import Kingfisher
import ReadMoreTextView

final class DetailViewController: UIViewController {

    // MARK: - Subviews

    @IBOutlet private var mainImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var bodyTextView: ReadMoreTextView!
    @IBOutlet private var showGalleryButton: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if let article = article {
            configure(with: article)
        }
    }

    private func configure(with article: Article) {
        mainImageView.kf.setImage(with: article.coverPhotoUrl)
        titleLabel.text = article.title
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/YY HH:mm"
        dateLabel.text = dateformatter.string(from: article.date)
        bodyTextView.text = article.body.htmlToString
        navigationItem.title = article.category

        if article.gallery == nil {
            showGalleryButton.alpha = 0
        } else {
            showGalleryButton.alpha = 1
        }
    }

    // MARK: - Injection

    var article: Article?

    // MARK: - Callbacks

    @IBAction func showGalleryAction(_ sender: UIButton) {
        print("tap")
    }
}

// MARK: - String extension

private extension String {
    private var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            return nil
        }
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
