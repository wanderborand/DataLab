//
//  PostsView.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 09.10.2024.
//

import SwiftUI

struct PostsView: View {
    @State private var recentsPosts: [Post] = []
    @State private var createNewPost: Bool = false
    
    var body: some View {
        NavigationStack {
            ReusablePostsView(posts: $recentsPosts)
                .hALign(.center).vALign(.center)
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        createNewPost.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .padding(13)
                            .background(.blue, in: Circle())
                    }
                    .padding(15)
                }
                .toolbar(content:{
                    ToolbarItem(placement: .navigationBarTrailing){
                        NavigationLink {
                            SearchUserView()
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .tint(.blue)
                                .scaleEffect(0.9)
                        }
                    }
                })
                .navigationTitle("Feed".localized)
        }
        .fullScreenCover(isPresented: $createNewPost) {
            CreateNewPost { post in
                recentsPosts.insert(post, at: 0)
            }
        }
    }
}

#Preview {
    PostsView()
}
