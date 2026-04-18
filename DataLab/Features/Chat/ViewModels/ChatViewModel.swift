//
//  ChatViewModel.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 25.02.2025.
//

import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    private let apiClient = ChatAPIClient()

    func sendMessage(_ text: String) async {
        let userMessage = Message(text: text, isUser: true)
        messages.append(userMessage)

        do {
            let response = try await apiClient.sendMessage(text)
            let botMessage = Message(text: response, isUser: false)
            messages.append(botMessage)
        } catch {
            let errorMessage = Message(text: "Error: \(error.localizedDescription)", isUser: false)
            messages.append(errorMessage)
        }
    }
}
