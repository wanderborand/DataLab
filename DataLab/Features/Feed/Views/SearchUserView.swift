//
//  SearchUserView.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 16.10.2024.
//

import SwiftUI
import FirebaseFirestore

struct SearchUserView: View {
    
    @State private var fetchedUsers: [User] = []
    @State private var searchText: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            ForEach(fetchedUsers){user in
                NavigationLink {
                    ReusableProfileContent(user: user)
                } label: {
                    Text(user.username)
                        .font(.callout)
                        .hALign(.leading)
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("SearchUser".localized)
        .searchable(text: $searchText)
        .onSubmit(of: .search, {
            Task {await searchUsers()}
        })
        .onChange(of: searchText) {
            if searchText.isEmpty {
                fetchedUsers = []
            }
        }
    }
    
    func searchUsers()async {
        do {
            let documents = try await Firestore.firestore().collection("Users")
                .whereField("username", isGreaterThanOrEqualTo: searchText)
                .whereField("username", isLessThanOrEqualTo: "\(searchText)\u{f8ff}")
                .getDocuments()
            
            let users = try documents.documents.compactMap { doc -> User? in
                try doc.data(as: User.self)
            }
            await MainActor.run(body: {
                fetchedUsers = users
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    SearchUserView()
}
