//
//  LoginViewModelProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol DataManager: AnyObject {
    func extractData()
}
protocol PictureDetailsViewModelProtocol: AnyObject, DataManager {
    var isLiked: Observable<Bool> { get set }
    func likeButtonTapped()
    func askApiToExtractImages(completion: @escaping([UnsplashImage]?, Error?) -> Void)
}
