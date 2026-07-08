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

    func createOrder(
          lineItems: [CartItem],
          customerId: Int,
          address: AddressItem,
          customerFirstName: String,
          customerLastName: String,
          customerPhone: String?,
          promo: ValidatedPromoCode?,
          discountAmount: Double,
          financialStatus: String = "pending",
          sendReceipt: Bool = true
      ) async throws -> Order {

          let shippingAddress = address.toOrderShippingAddress(
              firstName: customerFirstName,
              lastName: customerLastName,
              phone: customerPhone
          )

          let discountCodes: [ShopifyOrderRequestDTO.DiscountCode]? = promo.map {
              [.init(code: $0.code, amount: String(discountAmount))]
          }

          let requestBody = ShopifyOrderRequestDTO(
              order: .init(
                  line_items: lineItems.map { .init(variant_id: $0.variantId, quantity: $0.quantity) },
                  customer: .init(id: customerId),
                  shipping_address: shippingAddress,
                  discount_codes: discountCodes,
                  financial_status: financialStatus,
                  send_receipt: sendReceipt
              )
          )

          let response = try await remoteDataSource.createOrder(requestBody)
          return Order(
              id: response.order.id,
              name: response.order.name,
              total: response.order.totalPrice,
              financialStatus: response.order.financialStatus,
              fulfillmentStatus: response.order.fulfillmentStatus
          )
      }
}
