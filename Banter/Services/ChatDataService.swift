//
//  ChatDataService.swift
//  Banter
//
//  Created by RAHUL RANA on 12/02/26.
//

import Foundation
import CoreData

@MainActor
final class ChatDataService {

    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Chat Operations

    func fetchAllChats() -> [Chat] {
        let request: NSFetchRequest<Chat> = Chat.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "lastMessageTimestamp", ascending: false)]
        return (try? context.fetch(request)) ?? []
    }

    @discardableResult
    func createChat(title: String) -> Chat {
        let chat = Chat(context: context, title: title)
        save()
        return chat
    }

    func deleteChat(_ chat: Chat) {
        context.delete(chat)
        save()
    }

    func updateChatTitle(_ chat: Chat, title: String) {
        chat.title = title
        chat.updatedAt = Int64(Date().timeIntervalSince1970 * 1000)
        save()
    }

    // MARK: - Message Operations

    func fetchMessages(for chat: Chat) -> [Message] {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "chat == %@", chat)
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        return (try? context.fetch(request)) ?? []
    }

    @discardableResult
    func sendMessage(
        chat: Chat,
        text: String,
        type: MessageType = .text,
        sender: MessageSender,
        filePath: String? = nil,
        fileSize: Int64 = 0,
        thumbnailPath: String? = nil,
        timestamp: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    ) -> Message {
        let message = Message(
            context: context,
            chat: chat,
            message: text,
            type: type,
            sender: sender,
            filePath: filePath,
            fileSize: fileSize,
            thumbnailPath: thumbnailPath,
            timestamp: timestamp
        )

        chat.lastMessage = type == .file ? (text.isEmpty ? String.ChatDetail.sentAnImage : text) : text
        chat.lastMessageTimestamp = timestamp
        chat.updatedAt = timestamp

        save()
        return message
    }

    func userMessageCount(for chat: Chat) -> Int {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.predicate = NSPredicate(format: "chat == %@ AND senderRaw == %@", chat, MessageSender.user.rawValue)
        return (try? context.count(for: request)) ?? 0
    }

    // MARK: - Seed Data

    func seedDataIfNeeded() {
        let request: NSFetchRequest<Chat> = Chat.fetchRequest()
        let count = (try? context.count(for: request)) ?? 0
        guard count == 0 else { return }
        seedAllData()
    }

    // MARK: - Private

    private func save() {
        guard context.hasChanges else { return }
        try? context.save()
    }

    private func seedAllData() {
        // Chat 1: Mumbai Flight Booking
        let chat1 = Chat(context: context, title: "Mumbai Flight Booking")
        chat1.lastMessage = "The second option looks perfect! How do I proceed?"
        chat1.lastMessageTimestamp = 1703520480000
        chat1.createdAt = 1703520000000
        chat1.updatedAt = 1703520480000

        let chat1Data: [(String, MessageType, MessageSender, Int64, String?, Int64, String?)] = [
            ("Hi! I need help booking a flight to Mumbai.", .text, .user, 1703520000000, nil, 0, nil),
            ("Hello! I'd be happy to help you book a flight to Mumbai. When are you planning to travel?", .text, .agent, 1703520030000, nil, 0, nil),
            ("Next Friday, December 29th.", .text, .user, 1703520090000, nil, 0, nil),
            ("Great! And when would you like to return?", .text, .agent, 1703520120000, nil, 0, nil),
            ("January 5th. Also, I prefer morning flights.", .text, .user, 1703520180000, nil, 0, nil),
            ("Perfect! Let me search for morning flights. Could you share your departure city?", .text, .agent, 1703520210000, nil, 0, nil),
            ("", .file, .user, 1703520300000, "https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=400", 245680, "https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=100"),
            ("Thanks for sharing! I can see you prefer IndiGo. Let me find the best options.", .text, .agent, 1703520330000, nil, 0, nil),
            ("Flight options comparison", .file, .agent, 1703520420000, "https://images.unsplash.com/photo-1464037866556-6812c9d1c72e?w=400", 189420, "https://images.unsplash.com/photo-1464037866556-6812c9d1c72e?w=100"),
            ("The second option looks perfect! How do I proceed?", .text, .user, 1703520480000, nil, 0, nil),
        ]

        for m in chat1Data {
            _ = Message(context: context, chat: chat1, message: m.0, type: m.1, sender: m.2, filePath: m.4, fileSize: m.5, thumbnailPath: m.6, timestamp: m.3)
        }

        // Chat 2: Hotel Reservation Help
        let chat2 = Chat(context: context, title: "Hotel Reservation Help")
        chat2.lastMessage = "I've found 5 hotels in that area. Here's a comparison."
        chat2.lastMessageTimestamp = 1703450000000
        chat2.createdAt = 1703440000000
        chat2.updatedAt = 1703450000000

        let chat2Data: [(String, MessageType, MessageSender, Int64)] = [
            ("I need a hotel near Juhu Beach for New Year's Eve.", .text, .user, 1703440000000),
            ("Sure! How many nights are you planning to stay?", .text, .agent, 1703440060000),
            ("3 nights, checking in on the 30th.", .text, .user, 1703441000000),
            ("Got it. Any preferences for amenities? Pool, breakfast included?", .text, .agent, 1703442000000),
            ("Pool is a must, and breakfast would be nice.", .text, .user, 1703443000000),
            ("What's your budget range per night?", .text, .agent, 1703444000000),
            ("Around 5000-8000 INR per night.", .text, .user, 1703445000000),
            ("I've found 5 hotels in that area. Here's a comparison.", .text, .agent, 1703450000000),
        ]

        for m in chat2Data {
            _ = Message(context: context, chat: chat2, message: m.0, type: m.1, sender: m.2, timestamp: m.3)
        }

        // Chat 3: Restaurant Recommendations
        let chat3 = Chat(context: context, title: "Restaurant Recommendations")
        chat3.lastMessage = "Thanks! I'll check them out."
        chat3.lastMessageTimestamp = 1703380000000
        chat3.createdAt = 1703370000000
        chat3.updatedAt = 1703380000000

        let chat3Data: [(String, MessageType, MessageSender, Int64)] = [
            ("Can you suggest some good restaurants in Bandra?", .text, .user, 1703370000000),
            ("Of course! What type of cuisine are you in the mood for?", .text, .agent, 1703371000000),
            ("Something Italian or maybe seafood.", .text, .user, 1703372000000),
            ("Great choices! I'd recommend Bastian for seafood and Americano for Italian.", .text, .agent, 1703373000000),
            ("Are they expensive?", .text, .user, 1703374000000),
            ("Bastian is around 2500-3500 for two. Americano is more moderate at 1200-1800.", .text, .agent, 1703375000000),
            ("Do they take reservations?", .text, .user, 1703376000000),
            ("Yes, both accept reservations. I'd recommend booking ahead for the holidays.", .text, .agent, 1703377000000),
            ("Thanks! I'll check them out.", .text, .user, 1703380000000),
        ]

        for m in chat3Data {
            _ = Message(context: context, chat: chat3, message: m.0, type: m.1, sender: m.2, timestamp: m.3)
        }

        save()
    }
}
