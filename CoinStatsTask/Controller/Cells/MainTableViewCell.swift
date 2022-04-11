//
//  MainTableViewCell.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 07.04.22.
//

import UIKit

import Kingfisher

final class MainTableViewCell: UITableViewCell {

    let networkController = NetworkController.shared

    // MARK: - Subviews

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var contentImageView: UIImageView!
    @IBOutlet private var isReadImageView: UIImageView!

    // MARK: - Populate Cell

    func populate(with article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.category
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/YY HH:mm"
        dateLabel.text = dateformatter.string(from: article.date)
        checkIsRead(article.isRead)
        guard let placeholderImage = UIImage(systemName: "photo.artframe") else {
            return assertionFailure()
        }
        if let url = URL(string: article.coverPhotoUrl) {
            contentImageView.kf.indicatorType = .activity
            contentImageView.kf.setImage(
                with: url,
                placeholder: placeholderImage,
                options: [
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ]) { result in
                    switch result {
                    case .success(let value):
                        print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        } else {
            contentImageView.image = placeholderImage
        }
    }

    private func checkIsRead(_ isRead: Bool?) {
        if isRead == true {
            isReadImageView.image = UIImage(systemName: "checkmark.circle.fill")
            isReadImageView.tintColor = .blue
        } else {
            isReadImageView.image = UIImage(systemName: "checkmark.circle")
            isReadImageView.tintColor = .gray
        }
    }
}
