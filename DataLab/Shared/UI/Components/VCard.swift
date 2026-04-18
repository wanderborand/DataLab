//
//  VCard.swift
//  PetPal
//
//  Created by Andrew on 25.05.2023.
//

import SwiftUI

struct VCard: View {
    var cards: Cards
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(cards.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: 170, alignment: .leading)
                    .layoutPriority(1)
                Text(cards.subtitles)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(0.7)
            }
            
            Spacer()
            
            cards.image
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        }
        .foregroundColor(.white)
        .padding(30)
        .frame(width: 260, height: 310)
        .background(LinearGradient(colors: [cards.color, cards.color.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: cards.color.opacity(0.3), radius: 8, x: 0, y: 12)
    }
}

#Preview {
    VCard(cards: cards[0])
}


