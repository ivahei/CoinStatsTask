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
    @IBOutlet private var isRedImageView: UIImageView!

    // MARK: - Populate Cell

    func populate(with model: Article) {
        titleLabel.text = model.title
        descriptionLabel.text = model.category
        dateLabel.text = model.date.formatted(date: .omitted, time: .shortened)
        checkIsRed(model.isRed)
        guard let placeholderImage = UIImage(systemName: "photo.artframe") else {
            return assertionFailure()
        }
        contentImageView.kf.indicatorType = .activity
        contentImageView.kf.setImage(
            with: model.coverPhotoUrl,
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
    }

    private func checkIsRed(_ isRed: Bool?) {
        if isRed == true {
            isRedImageView.image = UIImage(systemName: "checkmark.circle.fill")
            isRedImageView.tintColor = .blue
        } else {
            isRedImageView.image = UIImage(systemName: "checkmark.circle")
            isRedImageView.tintColor = .gray
        }
    }
}
