//
//  ProductDetailsRepoImpl.swift
//  Drape
//
//  Created by Me3bed on 04/07/2026.
//
import Foundation

class ProductDetailsRepoImpl: ProductDetailsRepoProtocol {

    private let remoteDataSource: ProductDetailsDataSourceProtocol
    private let cartRepository: CartRepository
    private let keychain: KeychainTokenStorage

    init(
        remoteDataSource: ProductDetailsDataSourceProtocol = ProductDetailsDataSource(),
        cartRepository: CartRepository = CartRepositoryImpl(remoteDataSource: CartRemoteDataSource()),
        keychain: KeychainTokenStorage = KeychainTokenStorage()
    ) {
        self.remoteDataSource = remoteDataSource
        self.cartRepository = cartRepository
        self.keychain = keychain
    }

    func fetchProductDetails(productId: Int) async throws -> ProductDetailsEntity {
        let product = try await remoteDataSource.fetchProductDetails(productId: productId)
        return product.toEntity()
    }

    func addToCart(
        variantId: String,
        customerId: String,
        quantity: Int
    ) async throws -> Cart {

        let cart: Cart

        if let draftOrderId = keychain.getCartDraftOrderID() {
            let current = try await cartRepository.getDraftOrder(id: draftOrderId)
            var items = current.lineItems

            if let index = items.firstIndex(where: { $0.id == variantId }) {
                items[index].quantity = (items[index].quantity ?? 0) + quantity
            } else {
                items.append(
                    CartLineItem(id: variantId, lineItemId: 0, title: nil, size: nil, imageURL: nil, price: nil, quantity: quantity)
                )
            }
            cart = try await cartRepository.replaceLineItems(draftOrderId: draftOrderId, items: items)
        } else {
            cart = try await cartRepository.createDraftOrder(
                items: [
                    CartLineItem(
                        id: variantId,
                        lineItemId: 0,
                        title: nil,
                        size: nil,
                        imageURL: nil,
                        price: nil,
                        quantity: quantity
                    ),
                ], customerId: customerId
            )

            keychain.saveCartDraftOrderID(cart.draftOrderId)
        }

        return cart
    }
}
