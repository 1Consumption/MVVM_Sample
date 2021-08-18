//
//  NetworkManager.swift
//  Market_MVVM
//
//  Created by Olaf on 2021/08/16.
//

import Foundation

enum NetworkManagerError: Error {
    
    case emptyPath
    case requestError(Error)
    case invalidHTTPResponse
    case invalidStatusCode(Int)
    case emptyData
}

protocol NetworkManageable {
    
    func loadData(with urlString: String, completionHandler: @escaping (Result<Data, NetworkManagerError>) -> Void) -> URLSessionDataTask?
}

final class NetworkManager: NetworkManageable {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func loadData(with urlString: String, completionHandler: @escaping (Result<Data, NetworkManagerError>) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.emptyPath))
            return nil
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.failure(.requestError(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.invalidHTTPResponse))
                return
            }
            
            guard (200..<300) ~= response.statusCode else {
                completionHandler(.failure(.invalidStatusCode(response.statusCode)))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.emptyData))
                return
            }
            
            completionHandler(.success(data))
        }
        
        task.resume()
        
        return task
    }
}
