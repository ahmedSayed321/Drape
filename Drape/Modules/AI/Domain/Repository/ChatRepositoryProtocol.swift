//
//  ChatRepositoryProtocol.swift
//  Drape
//
//  Created by Moaz on 08/07/2026.
//

import Foundation

protocol ChatRepositoryProtocol {
    func sendMessage(_ text: String, history: [ChatMessage]) async throws -> ChatMessage
}
