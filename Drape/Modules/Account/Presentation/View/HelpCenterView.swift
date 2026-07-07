//
//  HelpCenterView.swift
//  Drape
//
//  Created by Moaz on 05/07/2026.
//

import SwiftUI

struct HelpCenterView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HelpCenterListView()
//            .navigationTitle("Help Center")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }){
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Help Center")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.black)
                }
            }
            
    }
}

#Preview {
    HelpCenterView()
}
