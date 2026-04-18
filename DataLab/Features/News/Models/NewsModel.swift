//
//  NewsModel.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 18.04.2026.
//

import Foundation

struct NewsItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let date: String
    let imageName: String
}

struct Webinar: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let url: URL
}
