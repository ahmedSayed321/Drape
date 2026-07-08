//
//  ChatEndpoint.swift
//  Drape
//
//  Created by Moaz on 08/07/2026.
//

import Foundation

enum ChatEndpoint: APIEndpoint {
    case sendMessage(ChatRequestDTO)

    var baseURL: String { ChatConfig.baseURL }

    var path: String {
        switch self {
        case .sendMessage:
            return "/chat"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .sendMessage:
            return .post
        }
    }

    var queryParameters: [String: String]? { nil }

    var body: Encodable? {
        switch self {
        case .sendMessage(let dto):
            return dto
        }
    }

    var headers: [String: String] {
        ChatConfig.defaultHeaders
    }
}
