//
//  UnsplashStorageService.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import CoreData

enum DataBaseProcessStatus: Error {
    case successfully
    case unableToExtractLikedImages
    case unableToAddLikedImage
    case unableToRemoveLikedImage
    case unableToFindImageForDelete
    case likedImagesDoNotExist
    case untrackedError(error: NSError)
}

enum CoreDataVerbs {
    case delete
    case add
}

class CoreDataService: CoreDataServiceProtocol {
    
    private let persistentContainer: NSPersistentContainer
    private var extractedImages = [LikedImage]()
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func extractLikedImages() {
        let viewContext = persistentContainer.viewContext
        do {
            let fetchedImages = try viewContext.fetch(LikedImage.fetchRequest())
            self.extractedImages = fetchedImages
        } catch {
            print(DataBaseProcessStatus.unableToExtractLikedImages)
        }
    }
    
    func addLikedImage(image: UnsplashImage) -> DataBaseProcessStatus {
        let viewContext = persistentContainer.viewContext
        let likedImage = LikedImage(context: viewContext)
        likedImage.id = image.id
        likedImage.fullPath = image.urls.regular
        likedImage.compressedPath = image.urls.small
        do {
            try viewContext.save()
            extractLikedImages()
            return DataBaseProcessStatus.successfully
        } catch {
            return DataBaseProcessStatus.unableToAddLikedImage
        }
    }
    
    func deleteLikedImage(image: UnsplashImage) -> DataBaseProcessStatus {
        let viewContext = persistentContainer.viewContext
        guard let managedObject = extractedImages.first(where: {$0.id == image.id}) else {
            return DataBaseProcessStatus.unableToFindImageForDelete
        }
        viewContext.delete(managedObject)
        do {
            try viewContext.save()
        } catch {
            return DataBaseProcessStatus.unableToRemoveLikedImage
        }
        return DataBaseProcessStatus.successfully
    }
    
    func getLikedImages() -> [LikedImage]? {
        self.extractLikedImages()
        return extractedImages
    }
}
