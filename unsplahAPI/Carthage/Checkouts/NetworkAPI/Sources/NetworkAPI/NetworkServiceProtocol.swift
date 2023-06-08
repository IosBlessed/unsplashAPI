//
//  UnsplashAPIService.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import Foundation

public protocol NetworkServiceProtocol: AnyObject {
    func startSessionForExtractingImages(
        urlPath: String,
        completion: @escaping (Result<Data, HTTPResponseCode>) -> Void
    )
}
