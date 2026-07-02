//
//  CustomSearchField.swift
//  Drape
//
//  Created by Moaz on 29/06/2026.
//

import SwiftUI

struct CustomSearchField: View {
    @Binding var text: String
    var onTextChanged: (String) -> Void = { _ in }
    @FocusState private var isTyping: Bool
    
    
    private var borderColor: Color {
        isTyping ? .black : .gray.opacity(0.4)
    }
    
    var body: some View {
        HStack (spacing:8){
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.gray.opacity(0.8))

   
                TextField("Search for clothes...", text: $text)
                    .focused($isTyping)
                    .onChange(of: text) { oldValue, newValue in
                        onTextChanged(newValue)
                    }
                
                Spacer()
                
                Image(systemName: "mic")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.gray.opacity(0.8))
                 
                
            }
            
            .padding(.horizontal, 20.0)
            .frame(height: 52)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: isTyping ? 2 : 1)
                    .fill(borderColor)
            }
            .animation(.easeInOut(duration: 0.2),value: isTyping)
             
        }
        
       
    }
}



#Preview {
    CustomSearchField(text: .constant(""))
}
