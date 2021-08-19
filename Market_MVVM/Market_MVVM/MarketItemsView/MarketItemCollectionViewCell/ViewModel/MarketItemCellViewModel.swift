//
//  MarketItemCellViewModel.swift
//  Market_MVVM
//
//  Created by Olaf on 2021/08/17.
//

import class UIKit.UIImage
import Foundation

enum MarketItemCellViewModelState {
    
    case empty
    case update(MarketItemCellViewModel.MetaData)
    case error(MarketItemCellViewModelError)
}

enum MarketItemCellViewModelError: Error {
    
    case emptyPath
    case useCaseError(ThumbnailUseCaseError)
    case emptyImage
}

final class MarketItemCellViewModel {
    
    struct MetaData {
        
        var image: UIImage?
        let title: String
        let needsDiscountedPriceLabelHidden: Bool
        let discountedPrice: NSAttributedString
        let originalPrice: String
    }
    
    private let marketItem: MarketItem
    private let useCase: ThumbnailUseCaseType
    private var imageTask: URLSessionDataTask?
    private var handler: ((MarketItemCellViewModelState) -> Void)?
    private var state: MarketItemCellViewModelState = .empty {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.handler?(state)
            }
        }
    }
    
    init(marketItem: MarketItem, useCase: ThumbnailUseCaseType = ThumbnailUseCase()) {
        self.marketItem = marketItem
        self.useCase = useCase
    }
    
    func bind(_ handler: @escaping (MarketItemCellViewModelState) -> Void) {
        self.handler = handler
    }
    
    func fire() {
        updateText()
        retrieveImage()
    }
    
    func retrieveImage() {
        guard let path = marketItem.thumbnails.first else {
            state = .error(.emptyPath)
            return
        }
        
        imageTask = useCase.retrieveImage(with: path,
                                          completionHandler: { [weak self] result in
                                            switch result {
                                            case .success(let data):
                                                guard let image = UIImage(data: data) else {
                                                    self?.state = .error(.emptyImage)
                                                    return
                                                }
                                                
                                                guard case var .update(metaData) = self?.state else {
                                                    return
                                                }
                                                
                                                metaData.image = image
                                                
                                                self?.state = .update(metaData)
                                                
                                            case .failure(let error):
                                                self?.state = .error(.useCaseError(error))
                                            }
                                          })
    }
    
    func cancelImageRequest() {
        imageTask?.cancel()
    }
    
    private func updateText() {
        let needsDiscountedPriceLabelHidden = marketItem.discountedPrice == nil
        let discountedPrice = needsDiscountedPriceLabelHidden ? .init() : "\(marketItem.currency) \(marketItem.price)".strikeThrough()
        let originalPrice = marketItem.currency + " " + (needsDiscountedPriceLabelHidden ? String(marketItem.price) : String(marketItem.discountedPrice ?? 0))
        
        let metaData = MetaData(image: nil,
                                title: marketItem.title,
                                needsDiscountedPriceLabelHidden: needsDiscountedPriceLabelHidden,
                                discountedPrice: discountedPrice,
                                originalPrice: originalPrice)
        
        state = .update(metaData)
    }
}
