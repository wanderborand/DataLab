//
//  ChartDataView.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 21.04.2026.
//

import SwiftUI
import Charts

struct ChartDataView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    @State private var showAddDataForm = false
    @State private var editingData: WorkData?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading".localized)
                        .padding()
                } else if viewModel.data.isEmpty {
                    emptyStateView
                } else {
                    chartAndLegend
                }
                
                Spacer()
                
                addButton
                    .padding()
            }
            .navigationTitle("MyStatistics".localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Label("", systemImage: "chevron.left")
                    }
                }
            }
            .sheet(isPresented: $showAddDataForm) {
                AddDataForm(workData: editingData) { newData in
                    viewModel.saveData(newData)
                }
            }
            .onAppear { viewModel.fetchData() }
        }
    }
    
    private var chartAndLegend: some View {
        VStack {
            Chart {
                ForEach(viewModel.data) { item in
                    BarMark(
                        x: .value("Year".localized, "\(item.year)"),
                        y: .value("Publications: ".localized, item.publications)
                    )
                    .foregroundStyle(Color.blue)
                    
                    BarMark(
                        x: .value("Year".localized, "\(item.year)"),
                        y: .value("Citations: ".localized, item.citations)
                    )
                    .foregroundStyle(Color.blue.opacity(0.4))
                }
            }
            .padding()
            
            legendView
        }
    }

    private var legendView: some View {
        HStack(spacing: 20) {
            LegendItem(color: .blue, label: "Publications: \(viewModel.totalPublications)")
            LegendItem(color: .blue.opacity(0.4), label: "Citations: \(viewModel.totalCitations)")
        }
        .padding(.top)
    }

    private var emptyStateView: some View {
        Text("DataMissing".localized)
            .foregroundColor(.gray)
            .padding()
    }

    private var addButton: some View {
        Button(action: {
            editingData = nil
            showAddDataForm.toggle()
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("AddData".localized)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }
}

struct LegendItem: View {
    let color: Color
    let label: String
    var body: some View {
        HStack(spacing: 5) {
            Circle().fill(color).frame(width: 10, height: 10)
            Text(label).font(.caption).foregroundColor(.secondary)
        }
    }
}
