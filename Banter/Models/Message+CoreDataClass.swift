//
//  Message+CoreDataClass.swift
//  Banter
//
//  Created by RAHUL RANA on 12/02/26.
//

import Foundation
import CoreData

enum MessageType: String {
    case text
    case file
}

enum MessageSender: String {
    case user
    case agent
}

@objc(Message)
public class Message: NSManagedObject {

    convenience init(
        context: NSManagedObjectContext,
        chat: Chat,
        message: String,
        type: MessageType = .text,
        sender: MessageSender,
        filePath: String? = nil,
        fileSize: Int64 = 0,
        thumbnailPath: String? = nil,
        timestamp: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    ) {
        self.init(context: context)
        self.id = UUID()
        self.chatId = chat.id
        self.message = message
        self.typeRaw = type.rawValue
        self.senderRaw = sender.rawValue
        self.filePath = filePath
        self.fileSize = fileSize
        self.thumbnailPath = thumbnailPath
        self.timestamp = timestamp
        self.chat = chat
    }

    var type: MessageType {
        get { MessageType(rawValue: typeRaw ?? "text") ?? .text }
        set { typeRaw = newValue.rawValue }
    }

    var sender: MessageSender {
        get { MessageSender(rawValue: senderRaw ?? "user") ?? .user }
        set { senderRaw = newValue.rawValue }
    }

    var isUser: Bool { sender == .user }
    var isFile: Bool { type == .file }

    var formattedFileSize: String? {
        guard fileSize > 0 else { return nil }
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: fileSize)
    }
}
