//
//  ChatView.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 22.10.2024.
//
//
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var newMessage = ""
    @State private var myProfile: User?
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack {
            if let myProfile = myProfile {
                Text("Hello, \(myProfile.username)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)
            } else {
                Text("Loading".localized)
                    .font(.title2)
                    .padding(.top)
            }
            
            ScrollView {
                ForEach(viewModel.messages) { message in
                    HStack {
                        if message.isUser {
                            Spacer()
                            Text(message.text)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        } else {
                            Text(message.text)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            HStack(spacing: 10) {
                TextField("EnterMessage".localized, text: $newMessage)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(25)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                Button(action: {
                    Task {
                        await viewModel.sendMessage(newMessage)
                        newMessage = ""
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemGray5))
            .cornerRadius(25, corners: [.topLeft, .topRight])
        }
        .navigationTitle("")
        .task {
            await fetchUserData()
        }
        .overlay {
            if isLoading {
                ProgressView()
            }
        }
    }
    
    func fetchUserData() async {
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        do {
            let user = try await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self)
            await MainActor.run {
                myProfile = user
                isLoading = false
            }
        } catch {
            print("Error loading profile: \(error.localizedDescription)")
            await MainActor.run {
                isLoading = false
            }
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
