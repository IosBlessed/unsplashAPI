//
//  LoginViewModelProtocol.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol LikedViewModelProtocol: AnyObject {
    var likedImages: Observable<[UnsplashImage]> { get set }
    func extractLikedImages()
}
