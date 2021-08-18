//
//  MarketItemsViewModel.swift
//  Market_MVVM
//
//  Created by Olaf on 2021/08/16.
//

import Foundation

enum MarketItemsViewModelError: Error {
    
    case useCaseError(MarketItemsUseCaseError)
    
    var message: String {
        return "대충 에러 메세지"
    }
}

enum MarketItemsViewModelState {
    
    case empty
    case update([IndexPath])
    case error(MarketItemsViewModelError)
}

final class MarketItemsViewModel {
    
    private let useCase: MarketItemsUseCaseType
    private var handler: ((MarketItemsViewModelState) -> Void)?
    
    private(set) var marketItems: [MarketItem] = [] {
        willSet {
            let indexPath = (marketItems.count..<newValue.count).map { IndexPath(item: $0, section: 0) }
            state = .update(indexPath)
        }
    }
    private var state: MarketItemsViewModelState = .empty {
        willSet {
            handler?(newValue)
        }
    }
    
    init(useCase: MarketItemsUseCaseType = MarketItemsUseCase()) {
        self.useCase = useCase
    }
    
    func bind(_ handler: @escaping ((MarketItemsViewModelState) -> Void)) {
        self.handler = handler
    }
    
    func showItems() {
        useCase.retrieveItems { [weak self] result in
            switch result {
            case .success(let marketItems):
                self?.marketItems.append(contentsOf: marketItems)
    
            case .failure(let error):
                self?.state = .error(.useCaseError(error))
            }
        }
    }
}
