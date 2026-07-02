//
//  RecentSearchesRepositoryImpl.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import Foundation

final class RecentSearchesRepositoryImpl: RecentSearchesRepositoryProtocol {
    private let localDataSource: RecentSearchesLocalDataSource
    private var searches: [String]

    init(localDataSource: RecentSearchesLocalDataSource = RecentSearchesLocalDataSource()) {
        self.localDataSource = localDataSource
        self.searches = localDataSource.getAll()
    }

    func getRecentSearches() -> [String] {
        searches
    }

    func save(_ query: String) {
        guard !query.isEmpty, !searches.contains(query) else { return }
        searches.insert(query, at: 0)
        localDataSource.save(searches)
    }

    func remove(_ query: String) {
        searches.removeAll { $0 == query }
        localDataSource.save(searches)
    }

    func clearAll() {
        searches.removeAll()
        localDataSource.save(searches)
    }
}
