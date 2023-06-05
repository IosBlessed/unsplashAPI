//
//  LoginViewModel.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//
import Foundation
final class BrowseViewModel: BrowseViewModelProtocol {
    var observedCellLayout: Observable<ObservableCellLayout>!
    var requestedImages: Observable<[UnsplashImage]> = Observable([])
    var occuredError: Observable<HTTPResponseCode> = Observable(.successfull)
    private var imageCollection: String?
    private var page: Int = 1
    private var photosCount: Int = 0
    private var categoryArray: [UnsplashImage] = []
    
    func userClickedOnToggleLayout(with collectionViewDisplayStyle: ImageDisplayStyle, cellsSize: SizesForCell) {
        switch collectionViewDisplayStyle {
        case .grid:
            // Convert to Portrait Layout
            observedCellLayout.observedObject = ObservableCellLayout(
                imageSystemNameForGrid: "square.grid.2x2",
                imageSystemNameForPortrait: "square.fill",
                cellSize: cellsSize.portraitSize
            )
        case .portrait:
            // Convert to Grid Layout
            observedCellLayout.observedObject = ObservableCellLayout(cellSize: cellsSize.gridSize)
        }
    }
    
    func requestImagesExtraction() {
        UnsplashAPI.shared.askUnsplashAPIToExtractImages(page: page, imageCollection: imageCollection) { [weak self] queryResult in
            guard let self else { return }
            switch queryResult {
            case .success(let extractedImages):
                extractedImages.forEach({self.categoryArray.append($0)})
                DispatchQueue.main.async {
                    self.requestedImages.observedObject = self.categoryArray
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.occuredError.observedObject = error
                }
            }
        }
        page += 1
    }

    
    func userSearchingImages(by imageCollection: String) {
        if self.imageCollection == imageCollection {
            self.requestImagesExtraction()
        } else {
            self.imageCollection = imageCollection.trimmingCharacters(in: .whitespaces) == "" ? nil : imageCollection
            categoryArray = []
            page = 1
            self.requestImagesExtraction()
        }
    }
}
