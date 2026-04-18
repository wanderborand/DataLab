//
//  CardSection.swift
//  PetPal
//
//  Created by Andrew on 25.05.2023.
//

import SwiftUI

struct CardSection: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var caption: String
    var color: Color
    var image: Image
    
    static func == (lhs: CardSection, rhs: CardSection) -> Bool {
        return lhs.id == rhs.id
    }
}

var cardSection = [
    CardSection(title: "MyStatistics".localized, caption: "InfluencerIndex".localized, color: Color(.blue), image: Image(systemName: "chart.bar.xaxis")),
    CardSection(title: "News".localized, caption: "ViewEvents".localized, color: Color("PurpleLightApp"), image: Image(systemName: "newspaper"))
]
