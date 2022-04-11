//
//  GalleryCollectionViewController.swift
//  CoinStatsTask
//
//  Created by Vahe Abazyan on 10.04.22.
//

import UIKit

import SwiftPhotoGallery

import Kingfisher

final class GalleryCollectionViewController: UICollectionViewController {

    var galleryItem: [Gallery]

    enum Section {
    case main
    }

    // MARK: - Initialization

    init?(coder: NSCoder, galleryItem: [Gallery]) {
        self.galleryItem = galleryItem
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("Cant be initialized")
    }

    @IBOutlet var galleryCollectionView: UICollectionView! { didSet {
        galleryCollectionView.collectionViewLayout = layoutWithTwoItemsInRow
        setDataSource()
    }}

    // MARK: - CollectionView Compositional Layout

    private lazy var layoutWithTwoItemsInRow: UICollectionViewCompositionalLayout = {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.4)
            ),
            subitem: item,
            count: 2
        )
        group.contentInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 8)
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)

        return UICollectionViewCompositionalLayout(section: section)
    }()

    private lazy var layoutWithThreeItemsInRow: UICollectionViewCompositionalLayout = {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.4)
            ),
            subitem: item,
            count: 3
        )
        group.contentInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 8)
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)

        return UICollectionViewCompositionalLayout(section: section)
    }()

    // MARK: - CollectionView Diffable DataSource

    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, Gallery>(
        collectionView: galleryCollectionView
    ) { [weak self] cv, indexPath, _ in
        guard
            let self = self,
            let cell = cv.dequeueReusableCell(
            withReuseIdentifier: "GalleryCollectionViewCell",
            for: indexPath
        ) as? GalleryCollectionViewCell
        else { fatalError() }
        cell.populate(with: self.galleryItem[indexPath.item])
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Pinch Gesture

extension GalleryCollectionViewController {
    @IBAction func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        if sender.scale >= 1.0 && galleryCollectionView.collectionViewLayout == layoutWithTwoItemsInRow {
            galleryCollectionView.setCollectionViewLayout(
                layoutWithThreeItemsInRow,
                animated: true
            ) } else if sender.scale < 1.0
                    && galleryCollectionView.collectionViewLayout == layoutWithThreeItemsInRow {
            galleryCollectionView.setCollectionViewLayout(layoutWithTwoItemsInRow, animated: true)
        }
    }
}

// MARK: - Collection View Methods

extension GalleryCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let gallery = SwiftPhotoGallery(delegate: self, dataSource: self)
        gallery.backgroundColor = .white
        gallery.pageIndicatorTintColor = .gray
        gallery.currentPageIndicatorTintColor = .black
        gallery.hidePageControl = false
        gallery.modalPresentationStyle = .overCurrentContext

        present(gallery, animated: false) {
            gallery.currentPage = indexPath.item
        }
    }

    func setDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Gallery>()
        snapshot.appendSections([.main])
        snapshot.appendItems(galleryItem)
        dataSource.apply(snapshot)
    }
}

// MARK: SwiftPhotoGalleryDataSource Methods

extension GalleryCollectionViewController: SwiftPhotoGalleryDataSource {

    func numberOfImagesInGallery(gallery: SwiftPhotoGallery) -> Int {
        return self.galleryItem.count
    }

    func imageInGallery(gallery: SwiftPhotoGallery, forIndex: Int) -> UIImage? {
        var image = UIImage()
        guard let contentUrl = URL(string: self.galleryItem[forIndex].contentUrl) else { return nil }
        downloadImage(with: contentUrl) { downloadedImage in
            if let downloadedImage = downloadedImage {
                image = downloadedImage
            }
        }
        return image
    }
}

// MARK: SwiftPhotoGalleryDelegate Methods

extension GalleryCollectionViewController: SwiftPhotoGalleryDelegate {

    func galleryDidTapToClose(gallery: SwiftPhotoGallery) {
        dismiss(animated: true)
    }
}

// MARK: - KingFisher

extension GalleryCollectionViewController {
    func downloadImage(with url: URL, imageCompletionHandler: @escaping (UIImage?) -> Void) {
        let resource = ImageResource(downloadURL: url)

        KingfisherManager.shared.retrieveImage(
            with: resource,
            options: nil,
            progressBlock: nil
        ) { result in
            switch result {
            case .success(let value):
                imageCompletionHandler(value.image)
            case .failure:
                imageCompletionHandler(nil)
            }
        }
    }
}
