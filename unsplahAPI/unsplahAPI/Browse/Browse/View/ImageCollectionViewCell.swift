//
//  ImageCollectionViewCell.swift
//  unsplahAPI
//
//  Created by Никита Данилович on 31.05.2023.
//
import SDWebImage
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var unsplashImageView: UIImageView!
    static let identifier = String(describing: ImageCollectionViewCell.self)
    static var nib: UINib = {
        return UINib(
            nibName: String(describing: ImageCollectionViewCell.self),
            bundle: nil)
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        unsplashImageView.layer.masksToBounds = true
        unsplashImageView.layer.cornerRadius = 20
    }
    
    func initialCellSetup(imageObject: UnsplashImage) {
        let imageUrl = URL(string: imageObject.urls.small)
        unsplashImageView.sd_setImage(
            with: imageUrl,
            placeholderImage: UIImage(named: "homeScreen.png"),
            context: nil
        )
    }
}

final class ObservableCellLayout {
    let imageSystemNameForGrid: String!
    let imageSystemNameForPortrait: String!
    let newCellSize: CGSize!
    
    init(
        imageSystemNameForGrid: String = "square.grid.2x2.fill",
        imageSystemNameForPortrait: String = "square",
        cellSize: CGSize
    ) {
        self.imageSystemNameForGrid = imageSystemNameForGrid
        self.imageSystemNameForPortrait = imageSystemNameForPortrait
        self.newCellSize = cellSize
    }
}

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
