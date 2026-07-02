//
//  RecentSearchesLocalDataSource.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import Foundation

final class RecentSearchesLocalDataSource {
    private let key = "recentSearches"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func getAll() -> [String] {
        defaults.stringArray(forKey: key) ?? []
    }

    func save(_ queries: [String]) {
        defaults.set(queries, forKey: key)
    }
}
