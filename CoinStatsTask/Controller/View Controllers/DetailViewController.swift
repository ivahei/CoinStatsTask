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

    // MARK: - initialisation

    init?(coder: NSCoder, article: Article) {
        self.article = article
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("Cant be initialized")
    }

    enum Section {
        case main
    }

    var article: Article

    // MARK: - SubViews

    @IBOutlet private var mainImageView: UIImageView! { didSet {
        mainImageView.kf.setImage(with: article.coverPhotoUrl)
    }}

    @IBOutlet private var titleLabel: UILabel! { didSet {
        titleLabel.text = article.title
    }}

    @IBOutlet private var dateLabel: UILabel! { didSet {
        dateLabel.text = article.date.formatted(date: .omitted, time: .shortened)
    }}

    @IBOutlet private var bodyTextView: ReadMoreTextView! { didSet {
        bodyTextView.attributedText = article.body.htmlToAttributedString
    }}

    @IBOutlet private var bodyTextViewHeightConstraint: NSLayoutConstraint!

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = article.category
        bodyTextView.delegate = self
    }
}

// MARK: - String extension

private extension String {
    var htmlToAttributedString: NSAttributedString? {
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

// MARK: - TextView Delegate

extension DetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        bodyTextViewHeightConstraint.constant = bodyTextView.contentSize.height
    }
}
