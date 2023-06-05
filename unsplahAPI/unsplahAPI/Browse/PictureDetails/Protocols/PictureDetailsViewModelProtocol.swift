//
//  LoginViewModelProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol PictureDetailsViewModelProtocol: AnyObject {
    var isLiked: Observable<Bool> { get set }
    func likeButtonTapped(for actionedImage: UnsplashImage)
    func checkIfImageIsLiked(for displayedImage: UnsplashImage, actionState: CheckImageState)
}
