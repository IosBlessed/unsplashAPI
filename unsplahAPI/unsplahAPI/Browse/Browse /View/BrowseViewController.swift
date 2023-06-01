//
//  BrowseViewController.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

enum ImagesSection: CaseIterable {
    case common
}

enum ImageDisplayStyle {
    case grid
    case portrait
}

struct SizesForCell {
    let gridSize: CGSize!
    let portraitSize: CGSize!
    
    init(gridSize: CGSize, portraitSize: CGSize) {
        self.gridSize = gridSize
        self.portraitSize = portraitSize
    }
}
// swiftlint:disable all
class BrowseViewController: UIViewController, BrowseViewControllerProtocol {
    @IBOutlet private unowned var browseView: UIView!
    @IBOutlet private weak var imageCollectionView: UICollectionView!
    var viewModel: BrowseViewModelProtocol!
    private var navbarSearchController: UISearchController!
    private lazy var imagesDataSource: UICollectionViewDiffableDataSource = {
        let dataSource = UICollectionViewDiffableDataSource<ImagesSection, UnsplashImage>(
            collectionView: imageCollectionView
        ) { (collectionView, indexPath, imageObject) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell
            cell?.initialCellSetup(imageObject: imageObject)
            return cell
        }
        return dataSource
    }()
    private var navigationBarRightButtonGrid: UIBarButtonItem!
    private var navigationBarRightButtonPortrait: UIBarButtonItem!
    private var imageDisplayStyle: ImageDisplayStyle = .grid
    private var collectionViewCellFlowLayout: UICollectionViewFlowLayout!
    private var sizesForCell: SizesForCell!
    private var extractedImagesFromUnsplash: [UnsplashImage] = []
    private var searchResult: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.requestImagesExtraction()
        setupNavigationBar()
        setupSizesForCell()
        setupCollectionView()
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.observedCellLayout.bind { [weak self] toggledObject in
            guard let self else { return }
            self.collectionViewCellFlowLayout.itemSize = toggledObject.newCellSize
            (self.navigationBarRightButtonGrid.customView as? UIButton)!
                .setBackgroundImage(
                    UIImage(systemName: toggledObject.imageSystemNameForGrid),
                    for: .normal
                )
            (self.navigationBarRightButtonPortrait.customView as? UIButton)!
                .setBackgroundImage(
                    UIImage(systemName: toggledObject.imageSystemNameForPortrait),
                    for: .normal
                )
            self.imageDisplayStyle = self.imageDisplayStyle == .grid ? .portrait : .grid
            self.updateCollectionViewDataSource()
            imageCollectionView.layoutSubviews()
        }
        viewModel.requestedImages.bind { [weak self] imageObjects in
            guard let self else { return }
            self.extractedImagesFromUnsplash = imageObjects
            self.updateCollectionViewDataSource()
        }
        viewModel.occuredError.bind { [weak self] error in
            guard let self else { return }
            
            let alertController = alertMessage(title: "WARNING!!!", description: error.rawValue, buttonTitle: "OK", handler: {_ in})
            self.present(alertController, animated: true)
        }
    }
    
    private func setupSizesForCell() {
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height
        sizesForCell = SizesForCell(
            gridSize: CGSize(width: (viewWidth - 70) / 2, height: viewHeight / 3.5),
            portraitSize: CGSize(width: viewWidth - 60, height: viewHeight / 2)
        )
        viewModel.observedCellLayout = Observable(ObservableCellLayout(cellSize: sizesForCell.gridSize))
    }
    
    private func setupNavigationBar() {
        navbarSearchController = UISearchController()
        let barButtonitemAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UIBarButtonItem.appearance().setTitleTextAttributes(barButtonitemAttributes, for: .normal)
        navbarSearchController.searchBar.placeholder = "Search"
        navigationItem.searchController = navbarSearchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchBar.setShowsScope(true, animated: true)
        navigationItem.searchController?.searchBar.searchTextField.addTarget(self, action: #selector(searchShouldBegin), for: .primaryActionTriggered)
        setupNavigationBarRightItems()
    }
    
    @objc private func searchShouldBegin() {
        guard let text = navigationItem.searchController?.searchBar.text?.lowercased() else { return }
        viewModel.userSearchingImages(by: text )
    }
    
    private func setupNavigationBarRightItems() {
        navigationBarRightButtonGrid = UIBarButtonItem.createRightBarButton(
            target: self,
            action: #selector(toggleImageCellLayout),
            imageSystemName: "square.grid.2x2.fill"
        )
        navigationBarRightButtonPortrait = UIBarButtonItem.createRightBarButton(
            target: self,
            action: #selector(toggleImageCellLayout),
            imageSystemName: "square"
        )
        navigationItem.rightBarButtonItems = [
            navigationBarRightButtonGrid,
            navigationBarRightButtonPortrait
        ]
    }
    @objc private func toggleImageCellLayout() {
        viewModel.userClickedOnToggleLayout(with: imageDisplayStyle, cellsSize: sizesForCell)
    }
    
    private func setupCollectionView() {
        imageCollectionView.register(
            ImageCollectionViewCell.nib,
            forCellWithReuseIdentifier: ImageCollectionViewCell.identifier
        )
        imageCollectionView.backgroundColor = .clear
        imageCollectionView.delegate = self
        collectionViewCellFlowLayout = UICollectionViewFlowLayout()
        collectionViewCellFlowLayout.itemSize = sizesForCell.gridSize
        collectionViewCellFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        collectionViewCellFlowLayout.minimumLineSpacing = 16
        imageCollectionView.collectionViewLayout = collectionViewCellFlowLayout
        view.layoutSubviews()
    }
    
    private func updateCollectionViewDataSource() {
        var imagesSnapshot = NSDiffableDataSourceSnapshot<ImagesSection, UnsplashImage>()
        // TODO: append items to imagesSnapshot
        imagesSnapshot.appendSections(ImagesSection.allCases)
        imagesSnapshot.appendItems(extractedImagesFromUnsplash)

        imagesDataSource.apply(imagesSnapshot, animatingDifferences: true)
    }
}

extension BrowseViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let interval = 10.0
        let topContentOffset = self.imageCollectionView.contentSize.height - self.imageCollectionView.bounds.height
        if scrollView.contentOffset.y <= topContentOffset && scrollView.contentOffset.y >= topContentOffset - interval {
            viewModel.requestImagesExtraction()
        }
    }
}

extension UIBarButtonItem {
    static func createRightBarButton(
        target: Any?,
        action: Selector,
        imageSystemName: String
    ) -> UIBarButtonItem {
        let button = UIButton(frame: .zero)
        button.setBackgroundImage(UIImage(systemName: imageSystemName), for: .normal)
        button.tintColor = .black
        button.addTarget(target, action: action, for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = true
        barButtonItem.customView?.frame = CGRect(x: 0, y: 0, width: 35, height: 30)
        
        return barButtonItem
    }
}

extension UIViewController {
    func generateAlertViewController(
        title: String,
        message: String,
        buttonOKTitle: String,
        actionButtonHandler: @escaping (UIAlertAction) -> Void
    ) -> UIAlertController {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertButtonAction = UIAlertAction(title: buttonOKTitle, style: .default, handler: actionButtonHandler)
        
        alertViewController.addAction(alertButtonAction)
        
        return alertViewController
    }
}
