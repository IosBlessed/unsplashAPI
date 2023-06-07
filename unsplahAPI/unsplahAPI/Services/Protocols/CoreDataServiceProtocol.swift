//
//  UnsplashStorageService.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

protocol CoreDataServiceProtocol: AnyObject {
    func extractLikedImages()
    func addLikedImage(image: UnsplashImage) -> DataBaseProcessStatus
    func deleteLikedImage(image: UnsplashImage) -> DataBaseProcessStatus
    func getLikedImages() -> [LikedImage]?
}
