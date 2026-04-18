//
//  Chart.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 26.11.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

struct WorkData: Identifiable, Codable {
    @DocumentID var id: String?
    var userUID: String
    var year: Int
    var publications: Int
    var citations: Int
}
