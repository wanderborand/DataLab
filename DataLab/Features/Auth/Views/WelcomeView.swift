//
//  WelcomeView.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 23.11.2024.
//

import SwiftUI

enum ViewStack {
    case login
    case registration
}

struct WelcomeView: View {
    @State private var presentNextView = false
    @State private var nextView: ViewStack = .login
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("WelcomeImg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 370)
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                
                Text("WelcomeTitle".localized)
                    .font(.system(size: 35, weight: . bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.blue)
                    .padding(.bottom, 8)
                
                Text("WelcomeSubTitle".localized)
                    .font(.system(size: 14, weight: . regular))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color("BlackApp"))
                    .padding(.bottom, 8)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button {
                        nextView = .login
                        presentNextView.toggle()
                    } label: {
                        Text("Login")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .frame(width: 160, height: 60)
                    .background(Color(.blue))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Button {
                        nextView = .registration
                        presentNextView.toggle()
                    } label: {
                        Text("Register")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color("BlackApp"))
                    }
                    .frame(width: 160, height: 60)
                }
                
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $presentNextView) {
                switch nextView {
                case .login:
                    LoginView()
                case .registration:
                    RegisterView()
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}


