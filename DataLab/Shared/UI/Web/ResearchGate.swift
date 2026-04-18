//
//  EnpuirWebView.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 05.11.2024.
//

import SwiftUI

struct ResearchGate: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            WebView(urlString: "https://www.researchgate.net/")
            
            VStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Back".localized)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Capsule().fill(Color.blue))
                }
                .padding()
                .padding(.bottom, 30)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    ResearchGate()
}

