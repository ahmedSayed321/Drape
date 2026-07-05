//
//  CheckoutRepositoryProtocol.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation

protocol CheckoutRepositoryProtocol {
    func updateDraftOrder(
            draftOrderId: Int,
            lineItems: [CartItem],
            address: AddressItem,
            customerFirstName: String,
            customerLastName: String,
            customerPhone: String?,
            promo: ValidatedPromoCode?,
            discountAmount: Double
        ) async throws -> DraftOrder
    
    func completeOrder(draftOrderId: Int, paymentPending: Bool) async throws -> DraftOrder
    
    func fetchDraftOrder(id: Int) async throws -> DraftOrder
}

