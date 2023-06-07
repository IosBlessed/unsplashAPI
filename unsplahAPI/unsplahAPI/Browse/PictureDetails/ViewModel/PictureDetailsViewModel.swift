//
//  LoginViewModel.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import UIKit

enum CheckImageState {
    case firstRun
    case likeButtonTapped
}

final class PictureDetailsViewModel: PictureDetailsViewModelProtocol {
    
    var isLiked: Observable<Bool> = Observable(false)
    
    func likeButtonTapped(for likedImage: UnsplashImage) {
        isLiked.observedObject = !isLiked.observedObject
        checkIfImageIsLiked(for: likedImage, actionState: .likeButtonTapped)
    }
    
    func checkIfImageIsLiked(for displayedImage: UnsplashImage, actionState: CheckImageState) {
        UnsplashAPI.shared.getStoredImageBasedOnUnsplashImage(
            unsplashImage: displayedImage
        ) { [weak self] queryResult in
            guard let self else { return }
            switch queryResult {
            case .success(let image):
                // check if image is in core data
                let isLiked = image != nil
                switch actionState {
                case .firstRun:
                    self.isLiked.observedObject = isLiked
                case .likeButtonTapped:
                    if isLiked {
                        // remove liked image from core data
                        UnsplashAPI.shared.manipulationWithLikedImage(
                            image: displayedImage,
                            action: .delete,
                            completion: { _ in }
                        )
                    } else {
                        // add liked image to core data
                        UnsplashAPI.shared.manipulationWithLikedImage(
                            image: displayedImage,
                            action: .add,
                            completion: { _ in }
                        )
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func extractData() {}
}
