//
//  EnpuirWebView.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 05.11.2024.
//

import SwiftUI

struct EnpuirWebView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            WebView(urlString: "https://enpuir.npu.edu.ua/")
            
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
    EnpuirWebView()
}

