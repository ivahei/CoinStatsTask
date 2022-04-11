//
//  GalleryCollectionViewCell.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 10.04.22.
//

import UIKit

import Kingfisher

final class GalleryCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var contentImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!

    func populate(with gallery: Gallery) {
        titleLabel.text = gallery.title

        setThumbnailImage(with: URL(string: gallery.thumbnailUrl))
        cashContentImage(with: URL(string: gallery.contentUrl))
    }

    private func setThumbnailImage(with url: URL?) {
        guard let placeholderImage = UIImage(systemName: "person.circle") else {
            return assertionFailure()
        }
        if let url = url {
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

    private func cashContentImage(with url: URL?) {
        if let url = url {
            KingfisherManager.shared.retrieveImage(
                with: url,
                options: [.cacheOriginalImage],
                progressBlock: nil
            ) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
