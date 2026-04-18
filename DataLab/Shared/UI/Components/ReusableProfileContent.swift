//
//  ReusableProfileContent.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 08.10.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReusableProfileContent: View {
    var user: User
    @State private var fetchedposts: [Post] = []
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    if let url = user.userProfileURL {
                        WebImage(url: url)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text(user.username)
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text(user.userBio)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(3)

                        if let bioLink = URL(string: user.userBioLink), !user.userBioLink.isEmpty {
                            Link(user.userBioLink, destination: bioLink)
                                .font(.callout)
                                .foregroundColor(.blue)
                                .lineLimit(1)
                                .truncationMode(.middle)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Text("Posts".localized)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("BlackApp"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 15)
                
                ReusablePostsView(basedOnUID: true, uid: user.userUID, posts: $fetchedposts)
            }
            .padding(15)
        }
    }
}
