//
//  ChatViewState.swift
//  Drape
//
//  Created by Moaz on 08/07/2026.
//

enum ChatViewState: Equatable {
    case idle
    case sending
    case error(String)
}
