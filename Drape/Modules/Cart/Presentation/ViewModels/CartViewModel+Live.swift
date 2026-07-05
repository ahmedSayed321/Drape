//
//  CartViewModel+Live.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import Foundation

extension CartViewModel {
    static func live(draftOrderId: String? = nil) -> CartViewModel {
        let repository = CartRepositoryImpl(
            remoteDataSource: CartRemoteDataSource()
        )
        return CartViewModel(
            getDraftOrderUseCase: GetDraftOrderUseCase(repository: repository),
            createDraftOrderUseCase: CreateDraftOrderUseCase(repository: repository),
            updateQuantityUseCase: UpdateCartItemQuantityUseCase(repository: repository),
            removeLineItemUseCase: RemoveCartLineItemUseCase(repository: repository),
            clearCartUseCase: ClearCartUseCase(repository: repository),
            draftOrderId: draftOrderId
        )
    }
}
