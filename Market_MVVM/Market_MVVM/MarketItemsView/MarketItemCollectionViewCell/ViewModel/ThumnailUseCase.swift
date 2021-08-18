//
//  ThumnailUseCase.swift
//  Market_MVVM
//
//  Created by Olaf on 2021/08/17.
//

import Foundation

enum ThumbnailUseCaseError: Error {
    
    case networkError(NetworkManagerError)
}

protocol ThumbnailUseCaseType {
    
    func retrieveImage(with path: String, completionHandler: @escaping (Result<Data, ThumbnailUseCaseError>) -> Void) -> URLSessionDataTask?
}

final class ThumbnailUseCase: ThumbnailUseCaseType {
    
    private let networkManager: NetworkManageable
    
    init(networkManager: NetworkManageable = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func retrieveImage(with path: String, completionHandler: @escaping (Result<Data, ThumbnailUseCaseError>) -> Void) -> URLSessionDataTask? {
        let task = networkManager.loadData(with: path,
                                           completionHandler: { result in
                                            let result = result
                                                .flatMapError { error -> Result<Data, ThumbnailUseCaseError> in
                                                    return .failure(.networkError(error))
                                                }
                                            
                                            completionHandler(result)
                                           })
        
        return task
    }
}
