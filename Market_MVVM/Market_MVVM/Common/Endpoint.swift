//
//  Endpoint.swift
//  Market_MVVM
//
//  Created by Olaf on 2021/08/18.
//

import Foundation

enum Endpoint {
    
    case items(page: Int)
    
    private static let scheme: String = "https://"
    private static let host: String = "camp-open-market-2.herokuapp.com/"
    
    var path: String {
        switch self {
        case .items(let page):
            return Endpoint.scheme + Endpoint.host +  "items/\(page)"
        }
    }
}
