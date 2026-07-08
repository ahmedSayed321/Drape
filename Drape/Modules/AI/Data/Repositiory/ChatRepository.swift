//
//  ChatRepository.swift
//  Drape
//
//  Created by Moaz on 08/07/2026.
//

import Foundation

final class ChatRepository: ChatRepositoryProtocol {
    private let networkService: NetworkService

    init(networkService: NetworkService = .shared) {
        self.networkService = networkService
    }

    func sendMessage(_ text: String, history: [ChatMessage]) async throws -> ChatMessage {
        let historyDTO = history.map {
            ChatHistoryItemDTO(role: $0.role.rawValue, content: $0.text)
        }
        let requestDTO = ChatRequestDTO(message: text, messages: historyDTO)

        let response: ChatResponseDTO = try await networkService.request(
            ChatEndpoint.sendMessage(requestDTO)
        )

        let products = response.products?.map { dto in
            Product(
                id: Int(dto.id) ?? 0,
                name: dto.title,
                brand: "",
                productType: "",
                price: dto.price,
                imageUrl: dto.imageURL,
                sizes: []
            )
        }

        return ChatMessage(role: .assistant, text: response.reply, products: products)
    }
}
