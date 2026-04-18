//
//  MainMenu.swift
//  PetPal
//
//  Created by Andrew on 24.05.2023.
//

import SwiftUI

struct ServicesMenu: View {
    
    @State private var selectedCard: Cards? = nil
    @State private var selectedVerticalCard: CardSection? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                content
            }
            .navigationTitle("ScientificRes".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("ScientificRes".localized)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
    
    var content: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(cards) { card in
                        GeometryReader { geometry in
                            VCard(cards: card)
                                .rotation3DEffect(
                                    Angle(degrees: Double(geometry.frame(in: .global).minX - 20) / -20),
                                    axis: (x: 0 , y: 10, z: 0)
                                )
                        }
                        .frame(width: 260, height: 310)
                        .onTapGesture {
                            selectedCard = card
                        }
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 12, trailing: 16))
            }
            .fullScreenCover(item: $selectedCard) { card in
                cardDetailView(for: card)
            }
            
            Text("Additionally".localized)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(Color("BlackApp"))
                .padding(.horizontal, 16)
                .padding(.top, 40)
            
            VStack(spacing: 20) {
                ForEach(cardSection) { section in
                    HCard(section: section)
                        .onTapGesture {
                            selectedVerticalCard = section
                        }
                }
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 16, trailing: 16))
            .fullScreenCover(item: $selectedVerticalCard) { section in
                verticalCardDetailView(for: section)
            }
        }
    }
    
    func cardDetailView(for card: Cards) -> some View {
        switch card {
        case cards[0]:
            return AnyView(ScholarGoogle())
        case cards[1]:
            return AnyView(WebOfScience())
        case cards[2]:
            return AnyView(ResearchGate())
        case cards[3]:
            return AnyView(ORCID())
        case cards[4]:
            return AnyView(EnpuirWebView())
        case cards[4]:
            return AnyView(Elsevier())
        default:
            return AnyView(EmptyView())
        }
    }
    
    func verticalCardDetailView(for section: CardSection) -> some View {
        switch section {
        case cardSection[0]:
            return AnyView(ChartDataView())
        case cardSection[1]:
            return AnyView(NewsAndWebinarsView())
        default:
            return AnyView(EmptyView())
        }
    }
}

#Preview {
    ServicesMenu()
}
