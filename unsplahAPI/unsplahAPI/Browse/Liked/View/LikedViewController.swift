//
//  LikedViewController.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

class LikedViewController: UIViewController, LikedViewControllerProtocol {
    // MARK: - Outlets
    @IBOutlet private weak var likedImageCollectionView: UICollectionView!
    // MARK: - Properties
    private lazy var dataSource: UICollectionViewDiffableDataSource = {
        let dataSource = UICollectionViewDiffableDataSource<ImagesSection, UnsplashImage>(
            collectionView: likedImageCollectionView
        ) { (collectionView, indexPath, likedImage) -> UICollectionViewCell? in
           let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCollectionViewCell.identifier,
                for: indexPath
           ) as? ImageCollectionViewCell
            cell?.initialCellSetup(imageObject: likedImage)
            return cell
        }
        return dataSource
    }()
    var viewModel: LikedViewModelProtocol!
    unowned var coordinator: BrowseCoordinatorProtocol!
    private var sizeForCell: SizesForCell!
    private var likedImages = [UnsplashImage]()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignedSystemColors.primary
        setupNavigationBar()
        setupSizeForCell()
        setupCollectionView()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.extractLikedImages()
        self.tabBarController?.tabBar.isHidden = false
    }
    // MARK: - Behaviour
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    private func setupSizeForCell() {
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height
        sizeForCell = SizesForCell(
            gridSize: CGSize(width: (viewWidth - 70) / 2, height: viewHeight / 3.5),
            portraitSize: CGSize(width: viewWidth - 60, height: viewHeight / 2)
        )
    }
    
    private func setupCollectionView() {
        likedImageCollectionView.register(
            ImageCollectionViewCell.nib,
            forCellWithReuseIdentifier: ImageCollectionViewCell.identifier
        )
        likedImageCollectionView.delegate = self
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = sizeForCell.gridSize
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        likedImageCollectionView.collectionViewLayout = collectionViewLayout
    }
    
    private func updateCollectionViewDataSource() {
        var imagesSnapshot = NSDiffableDataSourceSnapshot<ImagesSection, UnsplashImage>()
        imagesSnapshot.appendSections(ImagesSection.allCases)
        imagesSnapshot.appendItems(likedImages)
        dataSource.apply(imagesSnapshot, animatingDifferences: true)
    }
    
    private func setupBindings() {
        viewModel.likedImages.bind { [weak self] likedImages in
            guard let self else { return }
            DispatchQueue.main.async {
                self.likedImages = likedImages
                self.updateCollectionViewDataSource()
            }
        }
    }
}

extension LikedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let likedImage = likedImages[indexPath.row]
        self.coordinator.initializePictureDetails(
            fromNavigationController: self.navigationController,
            imageObject: likedImage
        )
    }
}
