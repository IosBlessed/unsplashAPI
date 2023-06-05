//
//  LikedImage+CoreDataProperties.swift
//  
//
//  Created by Никита Данилович on 05.06.2023.
//
//

import Foundation
import CoreData


extension LikedImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LikedImage> {
        return NSFetchRequest<LikedImage>(entityName: "LikedImage")
    }

    @NSManaged public var id: String!
    @NSManaged public var compressedPath: String!
    @NSManaged public var fullPath: String!

}
