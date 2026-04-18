//
//  APIConfig.swift
//  DataLab
//
//  Created by Andrew Bordiuk on 20.04.2026.
//

import Foundation

enum APIConfig {
    static var openAIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "CHAT_GPT_KEY") as? String else {
            fatalError("Error: CHAT_GPT_KEY not found in Info.plist.")
        }
        return key
    }
    
    static let baseURL = URL(string: "https://api.openai.com/v1/chat/completions")!
}
