//
//  FavoriteTopBarView.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 03/07/2026.
//

import SwiftUI

struct FavoriteTopBarView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
//                Button(action: {}) {
//                    Image(systemName: "arrow.left")
//                        .font(.title2)
//                        .foregroundColor(.black)
//                }
                
                Spacer()
                
                Text("Saved Items")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
//                Button(action: {}) {
//                    Image(systemName: "bell")
//                        .font(.title2)
//                        .foregroundColor(.black)
//                }
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 20)
            
        }
    }
}

#Preview {
    FavoriteTopBarView()
}
