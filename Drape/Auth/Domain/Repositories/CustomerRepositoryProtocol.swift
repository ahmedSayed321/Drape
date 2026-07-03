//
//  CustomerRepositoryProtocol.swift
//  Drape
//
//  Created by TaqieAllah on 30/06/2026.
//

import Foundation
protocol CustomerRepositoryProtocol {
    func createShopifyCustomer(fullName: String, email: String) async throws -> AppUser
    
    func fetchShopifyCustomerID(email: String) async throws -> String?

}
