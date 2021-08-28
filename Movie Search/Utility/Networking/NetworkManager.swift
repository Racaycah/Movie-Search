//
//  NetworkManager.swift
//  Movie Search
//
//  Created by Ata DORUK on 28.08.2021.
//

import UIKit

fileprivate enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum APIRequest {
    case search(query: String, page: Int)
    case movieDetails(id: Int)
    
    private var parameters: [URLQueryItem] {
        var queryItems: [URLQueryItem] = [URLQueryItem(name: "api_key", value: NetworkManager.apiKey)]
        
        switch self {
        case .search(query: let query, page: let page):
            queryItems.append(contentsOf: [
                URLQueryItem(name: "language", value: "en-US"),
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "include_adult", value: "false")
            ])
        case .movieDetails(id: let id):
            queryItems.append(contentsOf: [
                URLQueryItem(name: "id", value: "\(id)")
            ])
        }
        
        return queryItems
    }
    
    private var path: String {
        switch self {
        case .search: return "/3/search/movie"
        default: return ""
        }
    }
    
    var url: URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = self.path
        urlComponents.queryItems = self.parameters
        
        return urlComponents.url
    }
    
    fileprivate var httpMethod: HTTPMethod {
        .get
    }
}

enum RequestError: Error {
    case cantConstructUrl
    case unacceptableStatusCode(Int)
    case dataNil
    case decodingError
    case generic(Error)
}

class NetworkManager {
    private let session = URLSession.shared
    public static let apiKey: String = "4687a6e6b9bc52b250125617f3a85942"
    static let shared = NetworkManager()
    
    private init() {}
    
    
    private func request<T: Decodable>(_ requestType: APIRequest, decodingTo: T.Type, completion: @escaping (Result<T, RequestError>) -> Void) {
        guard let url = requestType.url else { completion(.failure(.cantConstructUrl)); return }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = requestType.httpMethod.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Get a reference in case we want to cancel ongoing requests later
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else { completion(.failure(.generic(error!))); return }
            
            let httpResponse = response as! HTTPURLResponse
            
            guard httpResponse.statusCode == 200 else { completion(.failure(.unacceptableStatusCode(httpResponse.statusCode))); return }
            
            guard let data = data else { completion(.failure(.dataNil)); return }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let object = try decoder.decode(T.self, from: data)
                
                completion(.success(object))
            } catch let error {
                print("Error: \(error)")
                if error is DecodingError {
                    completion(.failure(.decodingError))
                } else {
                    completion(.failure(.generic(error)))
                }
            }
        }
        
        task.resume()
    }
    
    func search(query: String, page: Int, completion: @escaping (Result<MovieListResult, RequestError>) -> Void) {
        request(.search(query: query, page: page), decodingTo: MovieListResult.self, completion: completion)
    }
}
