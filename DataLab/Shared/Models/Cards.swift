//
//  Cards.swift
//  PetPal
//
//  Created by Andrew on 25.05.2023.
//

import SwiftUI

struct Cards: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var subtitles: String
    var color: Color
    var image: Image
    
    static func == (lhs: Cards, rhs: Cards) -> Bool {
        return lhs.id == rhs.id
    }
}

var cards = [
    Cards(title: "Google Scholar", subtitles: "GoogleScholar".localized, color: Color(.blue), image: Image( "GoogleScholarLogo")),
    Cards(title: "Web Of Scince", subtitles: "WebOfScince".localized, color: Color("PurpleLightApp"), image: Image("WebOfScinceLogo")),
    Cards(title: "Research Gate", subtitles: " ", color: Color("GreenApp"), image: Image("ResearchGate")),
    Cards(title: "ORCID", subtitles: " ", color: Color("DarkGreenApp"), image: Image("ORCIDLogo")),
    Cards(title: "ENPUIR", subtitles: " ", color: Color("DarkGreen"), image: Image("EnpuirLogo")),
    Cards(title: "Elsevier", subtitles: " ", color: Color("GrayApp"), image: Image("ElsevierLogo"))
]

