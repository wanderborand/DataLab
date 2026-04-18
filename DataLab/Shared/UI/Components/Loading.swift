//
//  Loading.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 08.10.2024.
//

import SwiftUI

struct LoadingView: View {
    @Binding var show: Bool
    var body: some View {
        ZStack{
            if show {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2.0, anchor: .center)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { }
                    }
            }
        }
    }
}
