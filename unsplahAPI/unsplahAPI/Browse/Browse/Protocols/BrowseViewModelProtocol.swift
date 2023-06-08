//
//  LoginViewModelProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import Foundation
import NetworkAPI


protocol BrowseViewModelProtocol: AnyObject {
    var observedCellLayout: Observable<ObservableCellLayout>! { get set }
    var requestedImages: Observable<[UnsplashImage]> { get set }
    var occuredError: Observable<HTTPResponseCode> { get set }
    func userSearchingImages(by imageCollection: String)
    func userClickedOnToggleLayout(with collectionViewDisplayStyle: ImageDisplayStyle, cellsSize: SizesForCell)
    func requestImagesExtraction()
}
