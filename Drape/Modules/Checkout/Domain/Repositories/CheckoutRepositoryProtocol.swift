//
//  CheckoutRepositoryProtocol.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation

protocol CheckoutRepositoryProtocol {
    
    func createOrder(
          lineItems: [CartItem],
          customerId: Int,
          address: AddressItem,
          customerFirstName: String,
          customerLastName: String,
          customerPhone: String?,
          promo: ValidatedPromoCode?,
          discountAmount: Double,
          financialStatus: String,
          sendReceipt: Bool
      ) async throws -> OrderEntity

}

