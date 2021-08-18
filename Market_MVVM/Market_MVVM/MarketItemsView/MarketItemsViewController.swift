//
//  MarketItemsViewController.swift
//  Market_MVVM
//
//  Created by Olaf on 2021/08/16.
//

import UIKit

final class MarketItemsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel: MarketItemsViewModel = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        viewModel.bind { state in
            switch state {
            case .update(let indexPath):
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.insertItems(at: indexPath)
                }
                
            case .error(let error):
                DispatchQueue.main.async { [weak self] in
                    let alertController = UIAlertController(title: "에러", message: error.message, preferredStyle: .alert)
                    alertController.addAction(.init(title: "넵..!", style: .default, handler: nil))
                    self?.present(alertController, animated: true, completion: nil)
                }
                
            default:
                break
            }
        }
        
        viewModel.showItems()
    }
}

extension MarketItemsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.marketItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarketItemCell.identifier, for: indexPath) as? MarketItemCell else {
            return UICollectionViewCell()
        }
        
        let marketItem = viewModel.marketItems[indexPath.item]
        let marketItemCellViewModel = MarketItemCellViewModel(marketItem: marketItem)
        
        cell.bind(marketItemCellViewModel)
        cell.fire()
        
        return cell
    }
}

extension MarketItemsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.marketItems.count == indexPath.item + 2 {
            viewModel.showItems()
        }
    }
}
