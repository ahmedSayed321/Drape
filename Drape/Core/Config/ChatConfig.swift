//
//  ChatConfig.swift
//  Drape
//
//  Created by Moaz on 08/07/2026.
//

import Foundation

enum ChatConfig {
    static let hostname = "https://drape-chat-worker.drape-app.workers.dev"

    static var baseURL: String { hostname }

    static var defaultHeaders: [String: String] {
        ["Content-Type": "application/json"]
    }
}
