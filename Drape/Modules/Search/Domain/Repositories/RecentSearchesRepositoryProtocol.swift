//
//  RecentSearchesRepositoryProtocol.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import Foundation

protocol RecentSearchesRepositoryProtocol {
    func getRecentSearches() -> [String]
    func save(_ query: String)
    func remove(_ query: String)
    func clearAll()
}
