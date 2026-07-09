//
//  CartUIState.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import Foundation

struct CartUIState {
    let draftOrderId: String
    let lineItems: [CartLineItemUI]
    let subtotal: String
    let tax: String
    let shippingFee: String
    let total: String
    let invoiceURL: URL?
    
    // Calculated values
    let subtotalDecimal: Decimal
    let taxDecimal: Decimal
    let shippingFeeDecimal: Decimal
    let totalDecimal: Decimal

    init(from cart: Cart) {
        self.draftOrderId = cart.draftOrderId
        self.lineItems = cart.lineItems.map(CartLineItemUI.init)
        self.subtotalDecimal = cart.subtotal
        self.taxDecimal = cart.tax
        self.shippingFeeDecimal = cart.shippingFee
        self.totalDecimal = cart.total + cart.shippingFee

        self.subtotal = self.subtotalDecimal.formattedPrice
        self.tax = self.taxDecimal.formattedPrice
        self.shippingFee = self.shippingFeeDecimal.formattedPrice
        self.total = self.totalDecimal.formattedPrice
        self.invoiceURL = cart.invoiceURL
    }

    private init(
        draftOrderId: String,
        lineItems: [CartLineItemUI],
        subtotalDecimal: Decimal,
        taxDecimal: Decimal,
        shippingFeeDecimal: Decimal,
        totalDecimal: Decimal,
        invoiceURL: URL?
    ) {
        self.draftOrderId = draftOrderId
        self.lineItems = lineItems
        self.subtotalDecimal = subtotalDecimal
        self.taxDecimal = taxDecimal
        self.shippingFeeDecimal = shippingFeeDecimal
        self.totalDecimal = totalDecimal

        self.subtotal = subtotalDecimal.formattedPrice
        self.tax = taxDecimal.formattedPrice
        self.shippingFee = shippingFeeDecimal.formattedPrice
        self.total = totalDecimal.formattedPrice
        self.invoiceURL = invoiceURL
    }

    /// Return a new CartUIState with updated line items and recalculated totals.
    func updating(lineItems: [CartLineItemUI]) -> CartUIState {
        // Recalculate subtotal as sum(price * qty)
        let newSubtotal = lineItems.reduce(Decimal(0)) { acc, item in
            acc + (item.priceDecimal * Decimal(item.quantity))
        }

        // Recalculate tax proportionally if original subtotal > 0, otherwise keep original tax
        let newTax: Decimal
        if subtotalDecimal > 0 {
            let ratio = newSubtotal / subtotalDecimal
            newTax = taxDecimal * ratio
        } else {
            newTax = taxDecimal
        }

        // Keep shipping fee as-is (assumed fixed per order)
        let newShipping = shippingFeeDecimal

        let newTotal = newSubtotal + newTax + newShipping

        return CartUIState(
            draftOrderId: draftOrderId,
            lineItems: lineItems,
            subtotalDecimal: newSubtotal,
            taxDecimal: newTax,
            shippingFeeDecimal: newShipping,
            totalDecimal: newTotal,
            invoiceURL: invoiceURL
        )
    }
}

struct CartLineItemUI: Identifiable {
    let id: String
    let lineItemId: Int
    let title: String
    let size: String
    let imageURL: URL?
    let price: String
    let priceDecimal: Decimal
    let quantity: Int
    
    init(from item: CartLineItem) {
        self.id = item.id
        self.lineItemId = item.lineItemId
        self.title = item.title ?? "Unknown Item"
        self.size = item.size ?? "No Size"
        self.imageURL = item.imageURL
        self.priceDecimal = item.price ?? 0
        self.price = (item.price ?? 0).formattedPrice
        self.quantity = item.quantity ?? 0
    }

    init(id: String, lineItemId: Int, title: String, size: String, imageURL: URL?, priceDecimal: Decimal, quantity: Int) {
        self.id = id
        self.lineItemId = lineItemId
        self.title = title
        self.size = size
        self.imageURL = imageURL
        self.priceDecimal = priceDecimal
        self.price = priceDecimal.formattedPrice
        self.quantity = quantity
    }

    func updating(quantity: Int) -> CartLineItemUI {
        CartLineItemUI(
            id: id,
            lineItemId: lineItemId,
            title: title,
            size: size,
            imageURL: imageURL,
            priceDecimal: priceDecimal,
            quantity: quantity
        )
    }
    
    /// Convert back to domain CartLineItem for use with ViewModels
    func toDomainLineItem() -> CartLineItem {
        CartLineItem(
            id: id,
            lineItemId: lineItemId,
            title: title,
            size: size,
            imageURL: imageURL,
            price: priceDecimal,
            quantity: quantity
        )
    }
}
