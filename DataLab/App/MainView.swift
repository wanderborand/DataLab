//
//  MainView.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 08.10.2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            
            ServicesMenu()
                .tabItem {
                    Image(systemName: "sharedwithyou")
                    Text("Services".localized)
                }
            
            NoteListView()
                .tabItem {
                    Image(systemName: "note.text")
                    Text("Note".localized)
                }

            ChatView()
                .tabItem {
                    Image(systemName: "message")
                    Text("Chat".localized)
                }
            
            PostsView()
                .tabItem {
                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                    Text("Feed".localized)
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Profile".localized)
                }
        }
        .tint(.blue)
    }
}

#Preview {
    ContentView()
}
