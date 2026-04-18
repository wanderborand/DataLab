//
//  Notes.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 17.10.2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreCombineSwift

struct Note: Identifiable, Codable {
    @DocumentID var id: String?
    var userUID: String
    var title: String
    var content: String
    var reminderDate: Date
    var createdAt: Date
    var updatedAt: Date
}







