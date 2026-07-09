//
//  HelpCenterListView.swift
//  Drape
//
//  Created by Moaz on 05/07/2026.
//

import SwiftUI

enum IconSource {
    case system(String)
    case asset(String)
}

struct HelpCenterItem: Identifiable {
    let id = UUID()
    let icon: IconSource
    let title: String
}

extension HelpCenterItem {
    static let all: [HelpCenterItem] = [
        HelpCenterItem(
            icon: .system("headphones"),
            title: "Customer Service"
        ),
        HelpCenterItem(
            icon: .asset("whatsapp_icon"),
            title: "Whatsapp"
        ),
        HelpCenterItem(
            icon: .system("rectangle.on.rectangle"),
            title: "Website"
        ),
        HelpCenterItem(
            icon: .asset("facebook_icon"),
            title: "Facebook"
        ),
        HelpCenterItem(
            icon: .asset("twitter_icon"),
            title: "Twitter"
        ),
        HelpCenterItem(
            icon: .asset("instagram_icon"),
            title: "Instagram"
        )
    ]
}


struct HelpCenterListView: View {
    let items: [HelpCenterItem] = HelpCenterItem.all

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(items) { item in
                    Button {
                        // navigation logic
                    } label: {
                        HelpCenterItemView(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .clipped()
    }
}

#Preview {
    HelpCenterListView()
}
