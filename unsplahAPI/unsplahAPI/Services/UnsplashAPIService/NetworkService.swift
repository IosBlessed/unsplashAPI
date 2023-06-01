//
//  UnsplashAPIService.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//

import Network
import UIKit
// swiftlint:disable all
enum HTTPRequstMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case head = "HEAD"
}

enum HTTPResponseCode: String, Error {
    case badRequest = "Unfortunately your request didn't find any results!"
    case accessDenied = "Your access is denied!"
    case notFound = "Unfortunately your request didn't find any images!"
    case successfull
    case invalidHTTPRequest = "Something went wrong..."
    case invalidJSONDecoder = "Something went wrond, we are fixing it right now..."

    var responseCode: Int {
        switch self {
        case .successfull: return 200
        case .badRequest: return 400
        case .accessDenied: return 403
        case .notFound: return 404
        case .invalidHTTPRequest: return 406
        case .invalidJSONDecoder: return 407

        }
    }
}

final class NetworkService: NetworkServiceProtocol {
    func startSessionForExtractingImages(
        urlPath: String,
        completion: @escaping (Result<Data, HTTPResponseCode>) -> Void
    ) {
         requestImagesFromUnsplash(requestURLPath: urlPath) { data, _, error in
            guard let data = data else {
                return completion(.failure(error as! HTTPResponseCode))
            }
             return completion(.success(data))
        }
    }
    
    private func requestImagesFromUnsplash(
        requestURLPath: String,
        serverResponse: @escaping(Data?, URLResponse?, Error?) -> Void
    ) {
        do {
            guard let request = try generateSplashAPIRequest(
                for: requestURLPath,
                httpMethod: .get
            ) else {
                return serverResponse(nil, nil, HTTPResponseCode.invalidHTTPRequest)
            }
            let taskForRequest = URLSession.shared.dataTask(with: request) { data, response, error in
              return serverResponse(data, response, error)
            }
            taskForRequest.resume()
        } catch {
            return serverResponse(nil, nil, HTTPResponseCode.badRequest)
        }
    }

    private func generateSplashAPIRequest(
        for urlPath: String,
        _ timeoutInterval: Double = 60,
        httpMethod: HTTPRequstMethod,
        _ shouldHandleCookies: Bool = false
    ) throws -> URLRequest? {
        guard let url = URL(string: urlPath) else { throw HTTPResponseCode.badRequest}
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = ["Authorization": "Client-ID PC7FEYCaDwlYkA5t5pahlQQDQ9roy-USR3hhebZQbbk"]
        request.timeoutInterval = timeoutInterval
        request.httpShouldHandleCookies = shouldHandleCookies
        return request
    }
}

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
// swiftlint:enable all
