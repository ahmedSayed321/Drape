//
//  SendChatMessageUseCase.swift
//  Drape
//
//  Created by Moaz on 08/07/2026.
//

import Foundation

protocol SendChatMessageUseCaseProtocol {
    func execute(text: String, history: [ChatMessage]) async throws -> ChatMessage
}

final class SendChatMessageUseCase: SendChatMessageUseCaseProtocol {
    private let repository: ChatRepositoryProtocol

    init(repository: ChatRepositoryProtocol) {
        self.repository = repository
    }

    func execute(text: String, history: [ChatMessage]) async throws -> ChatMessage {
        try await repository.sendMessage(text, history: history)
    }
}
