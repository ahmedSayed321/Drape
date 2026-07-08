//
//  ChatMessage.swift
//  Drape
//
//  Created by Moaz on 08/07/2026.
//

import Foundation

struct ChatMessage: Identifiable, Equatable {
    
    let id: UUID
    let role: Role
    var text: String
    var products: [Product]?
    let date: Date

    enum Role: String, Equatable {
        case user
        case assistant
    }

    init(id: UUID = UUID(), role: Role, text: String, products: [Product]? = nil, date: Date = .now) {
        self.id = id
        self.role = role
        self.text = text
        self.products = products
        self.date = date
    }
}

extension ChatMessage {
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        if lhs.id != rhs.id { return false }
        if lhs.role != rhs.role { return false }
        if lhs.text != rhs.text { return false }
        if lhs.date != rhs.date { return false }

        switch (lhs.products, rhs.products) {
        case (nil, nil):
            return true
        case (let l?, let r?):
            let lIds = l.map { $0.id }
            let rIds = r.map { $0.id }
            return lIds == rIds
        default:
            return false
        }
    }
}
