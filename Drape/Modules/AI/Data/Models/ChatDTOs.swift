//
//  ChatDTOs.swift
//  Drape
//
//  Created by Moaz on 08/07/2026.
//

import Foundation

struct ChatRequestDTO: Encodable {
    let message: String
    let messages: [ChatHistoryItemDTO]
    
    enum CodingKeys: String, CodingKey {
        case message
        case messages
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
        try container.encode(messages, forKey: .messages)
    }
}

struct ChatHistoryItemDTO: Encodable {
    let role: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case role
        case content
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(role, forKey: .role)
        try container.encode(content, forKey: .content)
    }
}

struct ChatResponseDTO: Decodable {
    let reply: String
    let products: [ChatProductDTO]?
}

struct ChatProductDTO: Decodable {
    let id: String
    let title: String
    let price: String
    let imageURL: String?
}
