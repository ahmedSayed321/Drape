//
//  ProductRepositoryProtocol .swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import Foundation

protocol SearchRepositoryProtocol {
    func fetchAllProducts() async throws -> [Product]
}
