//
//  ModelChat.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 25.02.2025.
//

import Foundation

class ChatAPIClient {
    
    func sendMessage(_ message: String) async throws -> String {
        var request = URLRequest(url: APIConfig.baseURL)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(APIConfig.openAIKey)", forHTTPHeaderField: "Authorization")

        let chatRequest = ChatRequest(
            model: "gpt-3.5-turbo",
            messages: [ChatMessage(role: "user", content: message)]
        )
        request.httpBody = try JSONEncoder().encode(chatRequest)

        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode != 200 {
                let errorString = String(data: data, encoding: .utf8) ?? "Unknown Error"
                print("Status: \(httpResponse.statusCode), Error: \(errorString)")
                throw NSError(domain: "ChatAPIError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorString])
            }
        }

        let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        return decodedResponse.choices.first?.message.content ?? "No response"
    }
}
