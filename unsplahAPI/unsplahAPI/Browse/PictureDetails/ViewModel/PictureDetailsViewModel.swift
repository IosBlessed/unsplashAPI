//
//  LoginViewModel.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

final class PictureDetailsViewModel: PictureDetailsViewModelProtocol {
    
    var isLiked: Observable<Bool> = Observable(false)
    func likeButtonTapped() {
        isLiked.observedObject = !isLiked.observedObject
    }
    func extractData() {}
    // TODO: CoreData
    func askApiToExtractImages(completion: @escaping ([UnsplashImage]?, Error?) -> Void) {}
}
