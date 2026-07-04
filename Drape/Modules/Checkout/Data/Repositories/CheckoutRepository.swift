//
//  CheckoutRepository.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation


final class CheckoutRepository: CheckoutRepositoryProtocol {

    private let remoteDataSource: ShopifyCheckoutRemoteDataSource

    init(remoteDataSource: ShopifyCheckoutRemoteDataSource = ShopifyCheckoutRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }

    func createDraftOrder(
        lineItems: [CartItem],
        address: AddressItem,
        customerFirstName: String,
        customerLastName: String,
        customerPhone: String?,
        promo: ValidatedPromoCode?,
        discountAmount: Double
    ) async throws -> DraftOrder {

        let shippingAddress = address.toShippingAddress(
            firstName: customerFirstName,
            lastName: customerLastName,
            phone: customerPhone
        )

        let requestBody = ShopifyDraftOrderRequestDTO(
            draft_order: .init(
                line_items: lineItems.map { .init(variant_id: $0.variantId, quantity: $0.quantity) },
                shipping_address: shippingAddress,
                applied_discount: promo.map {
                    .init(
                        description: "Promo code \($0.code)",
                        value: String($0.value),
                        value_type: $0.valueType,
                        title: $0.code,
                        amount: String(discountAmount)
                    )
                },
                email: nil,
                note: address.locationNote
            )
        )

        let response = try await remoteDataSource.createDraftOrder(requestBody)
        return map(response.draftOrder)
    }

    func completeOrder(draftOrderId: Int, paymentPending: Bool) async throws -> DraftOrder {
        let response = try await remoteDataSource.completeDraftOrder(id: draftOrderId, paymentPending: paymentPending)
        return map(response.draftOrder)
    }

    func fetchDraftOrder(id: Int) async throws -> DraftOrder {
        let response = try await remoteDataSource.getDraftOrder(id: id)
        return map(response.draftOrder)
    }

    private func map(_ dto: ShopifyDraftOrderDTO) -> DraftOrder {
        DraftOrder(
            id: dto.id,
            name: dto.name,
            subtotal: dto.subtotalPrice,
            discountAmount: dto.appliedDiscount?.amount,
            total: dto.totalPrice,
            orderId: dto.orderId
        )
    }
}
