//
//  ChatDetailViewModel.swift
//  Banter
//
//  Created by RAHUL RANA on 12/02/26.
//

import Foundation
import SwiftUI
import CoreData
import Observation

@MainActor
@Observable
final class ChatDetailViewModel {

    private let dataService: ChatDataService
    private let agentService: AgentService

    let chat: Chat
    var messages: [Message] = []
    var draftText: String = ""
    var isAgentTyping: Bool = false
    var scrollToMessageId: NSManagedObjectID?

    init(chat: Chat, dataService: ChatDataService) {
        self.chat = chat
        self.dataService = dataService
        self.agentService = AgentService(dataService: dataService)
        loadMessages()
    }

    func loadMessages() {
        messages = dataService.fetchMessages(for: chat)
    }

    func sendTextMessage() {
        let text = draftText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        draftText = ""

        let message = dataService.sendMessage(
            chat: chat,
            text: text,
            type: .text,
            sender: .user
        )

        if messages.isEmpty {
            let titleText = String(text.prefix(40))
            dataService.updateChatTitle(chat, title: titleText)
        }

        messages.append(message)
        scrollToMessageId = message.objectID

        triggerAgentReply()
    }

    func sendImageMessage(image: UIImage) {
        Task {
            guard let saved = await ImageSaver.shared.saveImage(image) else { return }

            let message = dataService.sendMessage(
                chat: chat,
                text: "",
                type: .file,
                sender: .user,
                filePath: saved.path,
                fileSize: saved.fileSize,
                thumbnailPath: saved.thumbnailPath
            )

            if messages.isEmpty {
                dataService.updateChatTitle(chat, title: "Image Chat")
            }

            messages.append(message)
            scrollToMessageId = message.objectID

            triggerAgentReply()
        }
    }

    func updateTitle(_ newTitle: String) {
        let trimmed = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        dataService.updateChatTitle(chat, title: trimmed)
    }

    private func triggerAgentReply() {
        agentService.onUserMessageSent(
            chat: chat,
            onTyping: { [weak self] isTyping in
                self?.isAgentTyping = isTyping
            },
            onReply: { [weak self] message in
                guard let self else { return }
                self.isAgentTyping = false
                self.messages.append(message)
                self.scrollToMessageId = message.objectID
            }
        )
    }
}
