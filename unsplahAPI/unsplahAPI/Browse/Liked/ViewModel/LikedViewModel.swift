//
//  LoginViewModel.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

final class LikedViewModel: LikedViewModelProtocol {
    
    var likedImages: Observable<[UnsplashImage]> = Observable([UnsplashImage]())
    
    func extractLikedImages() {
        UnsplashAPI.shared.getWholeLikedImages { [weak self] likedImages in
            guard let self else { return }
            guard let likedImages else {
                print(DataBaseProcessStatus.unableToExtractLikedImages)
                return
            }
            self.likedImages.observedObject = likedImages.map { likedImage in
                let unsplashImage = UnsplashImage(
                    id: likedImage.id,
                    urls: UnsplashImageURL(
                        raw: "",
                        full: "",
                        regular: likedImage.fullPath,
                        small: likedImage.compressedPath,
                        thumb: "",
                        small_s3: ""
                    )
                )
                return unsplashImage
            }
        }
    }
}
