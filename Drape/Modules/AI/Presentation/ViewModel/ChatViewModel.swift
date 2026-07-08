//
//  ChatViewModel.swift
//  Drape
//
//  Created by Moaz on 08/07/2026.
//

import Foundation

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var state: ChatViewState = .idle

    private let sendMessageUseCase: SendChatMessageUseCaseProtocol

    init(sendMessageUseCase: SendChatMessageUseCaseProtocol) {
        self.sendMessageUseCase = sendMessageUseCase
        messages.append(
            ChatMessage(role: .assistant, text: "Hi! I can help you find products in Drape. What are you looking for?")
        )
    }

    func send() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, state != .sending else { return }

        let userMessage = ChatMessage(role: .user, text: trimmed)
        messages.append(userMessage)
        inputText = ""
        state = .sending

        Task {
            do {
                let history = messages
                let reply = try await sendMessageUseCase.execute(text: trimmed, history: history)
                messages.append(reply)
                state = .idle
            } catch {
                state = .error("Something went wrong. Please try again.")
                messages.append(ChatMessage(role: .assistant, text: "Sorry, I couldn't process that. Try again?"))
            }
        }
    }
}

extension ChatViewModel {
    static func live() -> ChatViewModel {
        let repository = ChatRepository()
        let useCase = SendChatMessageUseCase(repository: repository)
        return ChatViewModel(sendMessageUseCase: useCase)
    }
}
