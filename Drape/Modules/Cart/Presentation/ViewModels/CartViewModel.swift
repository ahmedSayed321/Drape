//
//  CartViewModel.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import Foundation

enum CartViewState {
    case loading
    case empty
    case success(CartUIState)
    case failure(String)
}

@MainActor
final class CartViewModel: ObservableObject {
    @Published private(set) var state: CartViewState = .loading
    @Published var syncErrorMessage: String?

    private let getDraftOrderUseCase: GetDraftOrderUseCaseProtocol
    private let createDraftOrderUseCase: CreateDraftOrderUseCaseProtocol
    private let updateQuantityUseCase: UpdateCartItemQuantityUseCaseProtocol
    private let removeLineItemUseCase: RemoveCartLineItemUseCaseProtocol
    private let clearCartUseCase: ClearCartUseCaseProtocol
    private let keychain: KeychainTokenStorage

    private var draftOrderId: String?
    var currentDraftOrderId: String? {
        draftOrderId
    }
    private var debounceTasks: [String: Task<Void, Never>] = [:]

    init(
        getDraftOrderUseCase: GetDraftOrderUseCaseProtocol,
        createDraftOrderUseCase: CreateDraftOrderUseCaseProtocol,
        updateQuantityUseCase: UpdateCartItemQuantityUseCaseProtocol,
        removeLineItemUseCase: RemoveCartLineItemUseCaseProtocol,
        clearCartUseCase: ClearCartUseCaseProtocol,
        keychain: KeychainTokenStorage = KeychainTokenStorage()
    ) {
        self.getDraftOrderUseCase = getDraftOrderUseCase
        self.createDraftOrderUseCase = createDraftOrderUseCase
        self.updateQuantityUseCase = updateQuantityUseCase
        self.removeLineItemUseCase = removeLineItemUseCase
        self.clearCartUseCase = clearCartUseCase
        self.keychain = keychain
        self.draftOrderId = keychain.getCartDraftOrderID()
    }

    func loadCart() async {
        guard let draftOrderId else {
            state = .empty
            return
        }
        state = .loading
        do {
            let cart = try await getDraftOrderUseCase.execute(id: draftOrderId)
            let uiState = CartUIState(from: cart)
            state = cart.lineItems.isEmpty ? .empty : .success(uiState)
        } catch {
            state = .failure("Couldn't load your cart. Please try again.")
        }
    }

    func createCart(with items: [CartLineItem]) async {
        state = .loading
        do {
            let newCart = try await createDraftOrderUseCase.execute(items: items,customerId:keychain.getShopifyCustomerID() ?? "")
            draftOrderId = newCart.draftOrderId
            keychain.saveCartDraftOrderID(newCart.draftOrderId) 
            let uiState = CartUIState(from: newCart)
            state = newCart.lineItems.isEmpty ? .empty : .success(uiState)
        } catch {
            state = .failure("Couldn't create your cart. Please try again.")
        }
    }

    func increment(_ item: CartLineItemUI) {
        applyLocalQuantityChange(item, delta: 1)
    }

    func decrement(_ item: CartLineItemUI) {
        guard item.quantity > 1 else { return }
        applyLocalQuantityChange(item, delta: -1)
    }

    private func applyLocalQuantityChange(_ item: CartLineItemUI, delta: Int) {
        guard case .success(let uiState) = state else { return }
        var updatedLineItems = uiState.lineItems
        if let index = updatedLineItems.firstIndex(where: { $0.id == item.id }) {
            let currentQuantity = updatedLineItems[index].quantity
            let newQuantity = max(0, currentQuantity + delta)
            updatedLineItems[index] = updatedLineItems[index].updating(quantity: newQuantity)

            let updatedUIState = uiState.updating(lineItems: updatedLineItems)
            state = .success(updatedUIState)
            debounceSync(itemId: item.id, newQuantity: newQuantity, previousQuantity: currentQuantity)
        }
    }

    private func debounceSync(itemId: String, newQuantity: Int, previousQuantity: Int) {
        debounceTasks[itemId]?.cancel()
        debounceTasks[itemId] = Task {
            try? await Task.sleep(for: .milliseconds(500))
            guard !Task.isCancelled else { return }
            await syncQuantity(itemId: itemId, quantity: newQuantity, previousQuantity: previousQuantity)
        }
    }


    private func syncQuantity(itemId: String, quantity: Int, previousQuantity: Int) async {
        guard let draftOrderId else { return }
        do {
            let cart = try await updateQuantityUseCase.execute(draftOrderId: draftOrderId, variantId: itemId, quantity: quantity)
            let uiState = CartUIState(from: cart)
            state = cart.lineItems.isEmpty ? .empty : .success(uiState)
        } catch {
            rollbackQuantity(itemId: itemId, to: previousQuantity)
            syncErrorMessage = "Couldn't update quantity. Please try again."
        }
    }

    private func rollbackQuantity(itemId: String, to previousQuantity: Int) {
        guard case .success(let uiState) = state else { return }
        var items = uiState.lineItems
        if let index = items.firstIndex(where: { $0.id == itemId }) {
            items[index] = items[index].updating(quantity: previousQuantity)
            state = .success(uiState.updating(lineItems: items))
        }
    }

    func removeItem(_ item: CartLineItemUI) async {
        guard let draftOrderId, case .success(let currentUIState) = state else { return }
        let previousState = state
        
        let updatedLineItems = currentUIState.lineItems.filter { $0.id != item.id }
        if updatedLineItems.isEmpty {
            state = .empty
        } else {
            let updatedUIState = currentUIState.updating(lineItems: updatedLineItems)
            state = .success(updatedUIState)
        }
        
        do {
            let updatedCart = try await removeLineItemUseCase.execute(draftOrderId: draftOrderId, variantId: item.id)
            let uiState = CartUIState(from: updatedCart)
            state = updatedCart.lineItems.isEmpty ? .empty : .success(uiState)
        } catch {
            state = .failure("Couldn't remove item. Please try again.")
            state = previousState
        }
    }

    func clearCart() async {
        guard let draftOrderId else { return }
        do {
            try await clearCartUseCase.execute(draftOrderId: draftOrderId)
            self.draftOrderId = nil
            keychain.clearCartDraftOrderID()
            state = .empty
        } catch {
            state = .failure("Couldn't clear your cart.")
        }
    }
}
