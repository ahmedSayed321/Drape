//
//  UIState.swift
//  Drape
//
//  Created by Me3bed on 04/07/2026.
//

import Foundation

enum ProductDetailsState {
    case idle
    case loading
    case success(ProductDetailsEntity)
    case failure(String)
}
