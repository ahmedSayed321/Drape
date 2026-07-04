//
//  NoItemsInCart.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import SwiftUI

struct NoItemsInCart: View {

   var body: some View {
       VStack(alignment: .center) {
           Image(systemName: "cart.fill")
               .font(.system(size: 52))
               .foregroundColor(Color(hex: "B3B3B3"))
               .padding(.bottom, 20)

           Text("Your Cart Is Empty!")
               .font(.system(size: 20, weight: .semibold))
            .padding(.bottom, 12)

           Text("When you add products, they’ll appear here.")
               .font(.system(size: 16, weight: .regular))
               .foregroundStyle(Color(hex: "808080"))
               .multilineTextAlignment(.center)

       }
       .padding(.horizontal, 70)
   }
}

#Preview {
   NoItemsInCart()
}

