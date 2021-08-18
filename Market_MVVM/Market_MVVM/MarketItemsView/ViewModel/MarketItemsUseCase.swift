//
//  MarketItemsUseCase.swift
//  Market_MVVM
//
//  Created by Olaf on 2021/08/16.
//

import Foundation

enum MarketItemsUseCaseError: Error {
    
    case networkError(NetworkManagerError)
    case decodeError
    case unknown
}

protocol MarketItemsUseCaseType {
    
    @discardableResult
    func retrieveItems(completionHandler: @escaping (Result<[MarketItem], MarketItemsUseCaseError>) -> Void) -> URLSessionDataTask?
}

final class MarketItemsUseCase: MarketItemsUseCaseType {
    
    private let networkManager: NetworkManageable
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }()
    private var page: Int = 1
    private var isLoading: Bool = false
    
    init(networkManager: NetworkManageable = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    @discardableResult
    func retrieveItems(completionHandler: @escaping (Result<[MarketItem], MarketItemsUseCaseError>) -> Void) -> URLSessionDataTask? {
        if isLoading {
            return nil
        }
        
        isLoading = true
        
        let path = Endpoint.items(page: page).path
        
        let task = networkManager.loadData(with: path) { [weak self] result in
            let result = result
                .flatMapError { .failure(.networkError($0)) }
                .flatMap { data -> Result<[MarketItem], MarketItemsUseCaseError> in
                    do {
                        guard let marketItems = try self?.decoder.decode(MarketItems.self, from: data) else {
                            return .failure(.unknown)
                        }
                        
                        self?.page = marketItems.page + 1
                        
                        return .success(marketItems.items)
                    } catch {
                        return .failure(.decodeError)
                    }
                }
            
            completionHandler(result)
            self?.isLoading = false
        }
        
        return task
    }
}
