//
//  AppService.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import Foundation
import UIKit

class UnsplashAPI {
    // MARK: - Singleton
    static let shared = UnsplashAPI()
    private init() {}
    
    // MARK: - Properties
    private let networkService: NetworkServiceProtocol = NetworkService()
    private let coreDataService: CoreDataServiceProtocol = CoreDataService(
        persistentContainer: (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer
    )
    // MARK: - Network
    func askUnsplashAPIToExtractImages(
        page: Int,
        imageCollection: String?,
        imagesReceiverHandler: @escaping(Result<[UnsplashImage], HTTPResponseCode>
        ) -> Void) {
        let isTargetQuery = imageCollection != nil
        let urlPath = self.linkBuilder(isTargetQuery: isTargetQuery, page: page, imageCollection: imageCollection)
        networkService.startSessionForExtractingImages(urlPath: urlPath) { queryResponse in
            switch queryResponse {
            case .success(let data):
                let decodeImagesResult = self.decodeJsonObjectToArrayOfImages(data: data, isTargetQuery: isTargetQuery)
                switch decodeImagesResult {
                case .success(let images):
                    return imagesReceiverHandler(.success(images))
                case .failure(let error):
                    return imagesReceiverHandler(.failure(error))
                }
            case .failure(let error):
                return imagesReceiverHandler(.failure(error))
            }
        }
    }
    
    private func decodeJsonObjectToArrayOfImages(
        data: Data,
        isTargetQuery: Bool
    ) -> Result <[UnsplashImage], HTTPResponseCode> {
        do {
            if isTargetQuery {
                let imagesObject = try JSONDecoder().decode(UnsplashSectionedImages.self, from: data)
                return .success(imagesObject.results)
            } else {
                let imagesArray = try JSONDecoder().decode([UnsplashImage].self, from: data)
                return .success(imagesArray)
            }
        } catch let error as HTTPResponseCode {
            return .failure(error)
        } catch {
            return .failure(.notFound)
        }
    }
    
    private func linkBuilder(isTargetQuery: Bool, page: Int, imageCollection: String? ) -> String {
        var linkToBuild = "https://api.unsplash.com/"
        linkToBuild += imageCollection == nil ? "photos?page=\(page)" : "search/photos?page=\(page)&query=\(imageCollection!)"
        return linkToBuild
    }
    
    // MARK: - CoreData
    func getStoredImageBasedOnUnsplashImage(
        unsplashImage searchingImage: UnsplashImage,
        completion: @escaping (Result<LikedImage?, DataBaseProcessStatus>) -> Void
    ) {
        guard let storagedImages = coreDataService.getLikedImages() else {
            return completion(.failure(.unableToExtractLikedImages))
        }
        let likedImage = storagedImages.first(where: {$0.id == searchingImage.id})
        return completion(.success(likedImage))
    }
    
    func manipulationWithLikedImage(
        image: UnsplashImage,
        action: CoreDataVerbs,
        completion: @escaping(DataBaseProcessStatus) -> Void
    ) {
        var status: DataBaseProcessStatus = .successfully
        switch action {
        case .add:
            status = coreDataService.addLikedImage(image: image)
        case .delete:
            status = coreDataService.deleteLikedImage(image: image)
        }
        return completion(status)
    }
    
    func getWholeLikedImages(completion: @escaping ([LikedImage]?) -> Void) {
        return completion(coreDataService.getLikedImages())
    }
    // MARK: - Keycahin
    // CRUD Keychain 
}
