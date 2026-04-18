//
//  StatisticsViewModel.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 21.04.2026.
//

import SwiftUI
import Combine

class StatisticsViewModel: ObservableObject {
    
    @Published var data: [WorkData] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let firebaseService = FirebaseService.shared
    
    func fetchData() {
        isLoading = true
        firebaseService.fetchWorkData { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let result = result {
                    self?.data = result
                } else {
                    self?.errorMessage = error?.localizedDescription
                }
            }
        }
    }
    
    func saveData(_ newData: WorkData) {
        firebaseService.saveWorkData(newData) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.fetchData()
                }
            }
        }
    }
    
    var totalPublications: Int { data.reduce(0) { $0 + $1.publications } }
    var totalCitations: Int { data.reduce(0) { $0 + $1.citations } }
}
