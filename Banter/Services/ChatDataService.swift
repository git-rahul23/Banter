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
        file: MessageFile? = nil,
        timestamp: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    ) -> Message {
        let message = Message(
            context: context,
            chat: chat,
            message: text,
            type: type,
            sender: sender,
            file: file,
            timestamp: timestamp
        )

        chat.lastMessage = type == .file ? (text.isEmpty ? String.ChatDetail.sentAnImage : text) : text
        chat.lastMessageTimestamp = timestamp
        chat.lastMessageSender = sender.rawValue
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

        let chat1Data: [(String, MessageSender, Int64)] = [
            ("Hi! I need help booking a flight to Mumbai.", .user, 1703520000000),
            ("Hello! I'd be happy to help you book a flight to Mumbai. When are you planning to travel?", .agent, 1703520030000),
            ("Next Friday, December 29th.", .user, 1703520090000),
            ("Great! And when would you like to return?", .agent, 1703520120000),
            ("January 5th. Also, I prefer morning flights.", .user, 1703520180000),
            ("Perfect! Let me search for morning flights. Could you share your departure city?", .agent, 1703520210000),
            ("I'll be flying from Delhi.", .user, 1703520300000),
            ("Thanks for sharing! Let me find the best IndiGo options for you.", .agent, 1703520330000),
            ("I found a few morning flights. The 6:30 AM and 9:15 AM departures look great.", .agent, 1703520420000),
            ("The second option looks perfect! How do I proceed?", .user, 1703520480000),
        ]

        chat1.lastMessageSender = MessageSender.user.rawValue
        for m in chat1Data {
            _ = Message(context: context, chat: chat1, message: m.0, type: .text, sender: m.1, timestamp: m.2)
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

        chat2.lastMessageSender = MessageSender.agent.rawValue
        
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
        
        chat3.lastMessageSender = MessageSender.user.rawValue

        for m in chat3Data {
            _ = Message(context: context, chat: chat3, message: m.0, type: m.1, sender: m.2, timestamp: m.3)
        }

        save()
    }
}
