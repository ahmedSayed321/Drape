//
//  CartMapper.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import Foundation

enum CartMapper {
    static func toDomain(_ dto: DraftOrderDTO) -> Cart {
        let lineItems = (dto.lineItems ?? []).map(mapLineItem)

        return Cart(
            draftOrderId: String(dto.id),
            lineItems: lineItems,
            subtotal: decimalValue(from: dto.subtotalPrice),
            tax: decimalValue(from: dto.totalTax),
            shippingFee: decimalValue(from: dto.shippingLine?.price),
            total: decimalValue(from: dto.totalPrice),
            invoiceURL: dto.invoiceUrl.flatMap(URL.init(string:))
        )
    }

    private static func mapLineItem(_ dto: DraftOrderLineItemDTO) -> CartLineItem {
        CartLineItem(
            id: String(dto.variantId ?? 0),
            lineItemId: dto.id ?? 0,
            title: dto.title,
            size: dto.variantTitle,
            imageURL: dto.imageURLString.flatMap(URL.init(string:)),
            price: Decimal(string: dto.price ?? ""),
            quantity: dto.quantity,
            productId: dto.productId
        )
    }

    private static func decimalValue(from string: String?) -> Decimal {
        guard let string, let value = Decimal(string: string) else { return 0 }
        return value
    }
}
