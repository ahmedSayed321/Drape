//
//  EmptyStateView.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 03/07/2026.
//
import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        Spacer()
        
        VStack(spacing: 16) {
            Image(systemName: "heart")
                .font(.system(size: 70, weight: .light))
                .foregroundColor(Color(.systemGray3))
            
            Text("No Saved Items!")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text("You don't have any saved items.\nGo to home and add some.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(.horizontal, 40)
        
        Spacer()
    }
}

#Preview {
    EmptyStateView()
}
