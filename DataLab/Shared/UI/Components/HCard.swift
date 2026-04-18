//
//  HCard.swift
//  PetPal
//
//  Created by Andrew on 25.05.2023.
//

import SwiftUI

struct HCard: View {
    var section: CardSection
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(section.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(section.caption)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
            }
            Divider()
                .frame(height: 50)
            section.image
                .font(.title)
                .foregroundColor(.white)
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: 110)
        .background(section.color)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: section.color.opacity(0.3), radius: 8, x: 0, y: 12)
    }
}

#Preview {
    HCard(section: cardSection[0])
}

