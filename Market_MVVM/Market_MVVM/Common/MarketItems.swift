//
//  MarketItems.swift
//  Market_MVVM
//
//  Created by Olaf on 2021/08/18.
//

import Foundation

struct MarketItems: Codable {
    
    let page: Int
    let items: [MarketItem]
}

struct MarketItem: Codable {
    
    let id: Int
    let title: String
    let price: Double
    let currency: String
    let discountedPrice: Double?
    let thumbnails: [String]
}
