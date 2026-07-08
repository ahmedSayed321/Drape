//
//  FAQViewModel.swift
//  Drape
//
//  Created by Moaz on 06/07/2026.
//
import Foundation

final class FAQViewModel: ObservableObject {
    @Published var selectedCategory: FAQCategory = .general
    @Published var expandedID: FAQItem.ID?
    @Published var searchText: String = ""

    private let allItems: [FAQItem]

    init(allItems: [FAQItem] = FAQItem.all) {
        self.allItems = allItems
    }

    var filteredItems: [FAQItem] {
        let categoryFiltered = allItems.filter { $0.category == selectedCategory }

        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return categoryFiltered
        }

        return categoryFiltered.filter {
            $0.question.localizedCaseInsensitiveContains(searchText) ||
            $0.answer.localizedCaseInsensitiveContains(searchText)
        }
    }

    func selectCategory(_ category: FAQCategory) {
        selectedCategory = category
        expandedID = nil
    }

    func toggleExpansion(for item: FAQItem) {
        expandedID = (expandedID == item.id) ? nil : item.id
    }

    func isExpanded(_ item: FAQItem) -> Bool {
        expandedID == item.id
    }

    func updateSearch(_ newValue: String) {
        searchText = newValue
        expandedID = nil 
    }
}
