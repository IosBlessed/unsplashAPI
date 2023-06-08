//
//  LoginModel.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import Foundation
//swiftlint: disable all
struct UnsplashSectionedImages: Codable, Hashable {
    let total: Int
    let total_pages: Int
    let results: [UnsplashImage]
}

struct UnsplashImage: Codable, Hashable {
    let id: String
    let urls: UnsplashImageURL
    static func == (lhs: UnsplashImage, rhs: UnsplashImage) -> Bool {
        lhs.id == rhs.id && lhs.urls == rhs.urls
    }
}

struct UnsplashImageURL: Codable, Hashable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
    let small_s3: String
}
