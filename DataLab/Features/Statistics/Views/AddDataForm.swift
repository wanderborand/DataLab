//
//  AddDataForm.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 21.04.2026.
//

import SwiftUI

struct AddDataForm: View {
    @State private var year: Int
    @State private var publications: Int
    @State private var citations: Int
    @State private var errorMessage: String?
    
    @Environment(\.presentationMode) var presentationMode
    
    var workData: WorkData?
    var onSave: (WorkData) -> Void
    
    init(workData: WorkData? = nil, onSave: @escaping (WorkData) -> Void) {
        _year = State(initialValue: workData?.year ?? Calendar.current.component(.year, from: Date()))
        _publications = State(initialValue: workData?.publications ?? 0)
        _citations = State(initialValue: workData?.citations ?? 0)
        self.workData = workData
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                formHeader
                formFields
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 5)
                }
                
                Spacer()
                actionButtons
            }
            .padding()
        }
    }
    
    private var formHeader: some View {
        VStack(spacing: 15) {
            Text(workData == nil ? "AddData".localized : "EditData".localized)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Text("NumberOfpublic".localized)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
        }
        .padding(.top)
    }
    
    private var formFields: some View {
        VStack(spacing: 20) {
            yearPicker
            
            Stepper("Publications: \(publications)", value: $publications, in: 0...1000)
            Stepper("Citations: \(citations)", value: $citations, in: 0...10000)
        }
    }
    
    private var yearPicker: some View {
        HStack {
            Text("Year".localized)
                .fontWeight(.semibold)
            
            Picker("Year".localized, selection: $year) {
                ForEach(1995...Calendar.current.component(.year, from: Date()), id: \.self) { year in
                    Text("\(year)").tag(year)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(maxHeight: 120)
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 15) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel".localized)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
            }
            
            Button(action: saveData) {
                Text("Save".localized)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
    }
    
    private func saveData() {
        guard year >= 1995 else {
            errorMessage = "YearLimit".localized
            return
        }
        
        guard publications > 0 || citations > 0 else {
            errorMessage = "NotZero".localized
            return
        }
        
        let newData = WorkData(
            userUID: "",
            year: year,
            publications: publications,
            citations: citations
        )
        
        onSave(newData)
        presentationMode.wrappedValue.dismiss()
    }
}
