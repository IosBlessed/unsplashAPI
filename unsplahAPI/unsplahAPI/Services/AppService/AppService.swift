//
//  AppService.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import Foundation
// TODO: Whole API logic
class UnsplashAPI {
    
    static let shared = UnsplashAPI()
    
    private init() {}
    // MARK: - Network
    private let networkService: NetworkServiceProtocol = NetworkService()
    
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
    
    // MARK: - Storage
    // CRUD database
    
    // MARK: - Keycahin
    // CRUD Keychain 
}
