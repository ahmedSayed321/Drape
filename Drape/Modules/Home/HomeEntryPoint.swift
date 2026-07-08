//
//  HomeEntryPoint.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//



import SwiftUI

struct HomeEntryPoint: View {
    @Environment(\.modelContext) private var context

    var body: some View {
        HomeModuleFactory.makeHomeView(modelContext: context)
    }
}
