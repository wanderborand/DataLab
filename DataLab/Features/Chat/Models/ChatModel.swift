//
//  ChatModelT.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 25.02.2025.
//

import Foundation

struct ChatRequest: Encodable {
    let model: String
    let messages: [ChatMessage]
}

struct ChatMessage: Codable {
    let role: String
    let content: String
}

struct APIResponse: Decodable {
    let choices: [Choice]
}

struct Choice: Decodable {
    let message: ChatMessage
}

struct Message: Identifiable, Codable {
    var id = UUID()
    let text: String
    let isUser: Bool
}
