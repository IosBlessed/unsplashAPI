//
//  UnsplashAPIService.swift
//  unsplashAPI
//
//  Created by Никита Данилович on 25.05.2023.
//
#if os(iOS) && canImport(UIKit)
import UIKit
#endif
import Foundation

public enum HTTPRequstMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case head = "HEAD"
}

public enum HTTPResponseCode: String, Error {
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

public class NetworkService: NetworkServiceProtocol {
    
    public init() { }
    
    public func startSessionForExtractingImages(
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
    
    public func requestImagesFromUnsplash(
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

    public func generateSplashAPIRequest(
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
