//
//  MarketItemCell.swift
//  Market_MVVM
//
//  Created by Olaf on 2021/08/17.
//

import UIKit

final class MarketItemCell: UICollectionViewCell {
    
    static let identifier: String = "MarketItemCell"
    
    private var viewModel: MarketItemCellViewModel?
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var discountedPriceLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        reset()
    }
    
    func bind(_ viewModel: MarketItemCellViewModel) {
        self.viewModel = viewModel
        
        viewModel.bind { [weak self] state in
            switch state {
            case .update(let metaData):
                self?.imageView.image = metaData.image
                self?.titleLabel.text = metaData.title
                self?.priceLabel.text = metaData.originalPrice
                self?.discountedPriceLabel.isHidden = metaData.needsDiscountedPriceLabelHidden
                self?.discountedPriceLabel.attributedText = metaData.discountedPrice
                
            case .error(_):
                self?.imageView.image = UIImage(named: "image")
                
            default:
                break
            }
        }
    }
    
    func fire() {
        viewModel?.fire()
    }
    
    private func reset() {
        viewModel?.cancelImageRequest()
        imageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        discountedPriceLabel.text = nil
    }
}
