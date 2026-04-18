//
//  NuewsView.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 25.02.2025.
//

import SwiftUI

enum ContentTab: String, CaseIterable {
    case news = "News"
    case webinars = "Webinars"
}

struct NewsAndWebinarsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: ContentTab = .news
    
    let newsItems = [
        NewsItem(title: "News Item",
                 description: "description...",
                 date: "February 25, 2025",
                 imageName: "News1"),
        NewsItem(title: "News Item",
                 description: "description...",
                 date: "February 25, 2025",
                 imageName: "News2")
    ]
    
    let webinars = [
        Webinar(title: "Webinar Title",
                date: "February 25, 2025",
                url: URL(string: "https://example.com/webinar1")!),
        Webinar(title: "Webinar Title",
                date: "February 25, 2025",
                url: URL(string: "https://example.com/webinar2")!)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                customTabBar
                
                TabView(selection: $selectedTab) {
                    newsList.tag(ContentTab.news)
                    webinarsList.tag(ContentTab.webinars)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Label("Back", systemImage: "chevron.left")
                            .fontWeight(.medium)
                    }
                }
            }
        }
    }
    
    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(ContentTab.allCases, id: \.self) { tab in
                TabButton(title: tab.rawValue, isSelected: selectedTab == tab) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal)
        .background(Color(.systemBackground))
    }
    
    private var newsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(newsItems) { item in
                    NewsCard(item: item)
                }
            }
            .padding()
        }
    }
    
    private var webinarsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(webinars) { webinar in
                    WebinarCard(webinar: webinar)
                }
            }
            .padding()
        }
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(isSelected ? .blue : .secondary)
                
                ZStack {
                    Capsule()
                        .fill(Color.clear)
                        .frame(height: 3)
                    if isSelected {
                        Capsule()
                            .fill(Color.blue)
                            .frame(width: 40, height: 3)
                            .matchedGeometryEffect(id: "tab", in: tabAnimation)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
        }
    }
    @Namespace private var tabAnimation
}

struct NewsCard: View {
    let item: NewsItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(item.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 180)
                .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(item.date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(item.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(item.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding()
        }
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct WebinarCard: View {
    let webinar: Webinar
    
    var body: some View {
        Link(destination: webinar.url) {
            HStack(spacing: 16) {
                Image(systemName: "video.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Circle().fill(Color.blue))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(webinar.title)
                        .font(.body.weight(.semibold))
                        .foregroundColor(.primary)
                    
                    Text(webinar.date)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}
#Preview {
    NewsAndWebinarsView()
}
