//
//  AgentService.swift
//  Banter
//
//  Created by RAHUL RANA on 12/02/26.
//

import Foundation

@MainActor
final class AgentService {

    private let dataService: ChatDataService
    private var debounceTask: Task<Void, Never>?
    private var messagesSinceLastReply: Int = 0
    private var nextReplyThreshold: Int = Int.random(in: 4...5)

    static let predefinedResponses = [
        "I'm looking into that for you.",
        "Let me check the details.",
        "Got it! I'll help you with that.",
        "That's a great question. Here's what I found...",
        "I've processed your request.",
        "Sure, let me work on that right away.",
        "Here's what I came up with.",
        "Let me pull up the relevant information.",
        "I'll have that sorted out shortly.",
        "Thanks for the details! Processing now.",
        "Absolutely, here's my recommendation.",
        "I found a few options for you.",
        "Let me get back to you on that in a moment.",
        "Working on it! Almost there.",
        "Here are the results of my search."
    ]

    static let placeholderImages = [
        "https://picsum.photos/400/300",
        "https://picsum.photos/seed/banter1/400/300",
        "https://picsum.photos/seed/banter2/400/300",
        "https://picsum.photos/seed/banter3/400/300",
        "https://picsum.photos/seed/banter4/400/300"
    ]

    init(dataService: ChatDataService) {
        self.dataService = dataService
    }

    /// Called after every user message. Agent replies every 4-5 user messages.
    func onUserMessageSent(chat: Chat, onTyping: @escaping (Bool) -> Void, onReply: @escaping (Message) -> Void) {
        debounceTask?.cancel()
        messagesSinceLastReply += 1

        debounceTask = Task {
            try? await Task.sleep(for: .milliseconds(500))
            guard !Task.isCancelled else { return }

            guard messagesSinceLastReply >= nextReplyThreshold else { return }

            // Reset counter and pick next random threshold
            messagesSinceLastReply = 0
            nextReplyThreshold = Int.random(in: 4...5)

            // Show typing indicator
            onTyping(true)

            // Simulate thinking delay: 2 seconds
            let delay = Int(2000)
            try? await Task.sleep(for: .milliseconds(delay))
            guard !Task.isCancelled else { return }

            let isText = Double.random(in: 0...1) < 0.7

            if isText {
                let response = Self.predefinedResponses.randomElement()!
                let message = dataService.sendMessage(
                    chat: chat,
                    text: response,
                    type: .text,
                    sender: .agent
                )
                onReply(message)
            } else {
                let imageUrl = Self.placeholderImages.randomElement()!
                let message = dataService.sendMessage(
                    chat: chat,
                    text: "",
                    type: .file,
                    sender: .agent,
                    filePath: imageUrl,
                    fileSize: Int64.random(in: 100_000...500_000),
                    thumbnailPath: imageUrl
                )
                onReply(message)
            }
        }
    }
}
