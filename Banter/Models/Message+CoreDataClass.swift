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

struct MessageThumbnail {
    let path: String
}

struct MessageFile {
    let path: String
    let fileSize: Int64
    let thumbnail: MessageThumbnail?

    var formattedFileSize: String? {
        guard fileSize > 0 else { return nil }
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: fileSize)
    }
}

@objc(Message)
public class Message: NSManagedObject {

    convenience init(
        context: NSManagedObjectContext,
        chat: Chat,
        message: String,
        type: MessageType = .text,
        sender: MessageSender,
        file: MessageFile? = nil,
        timestamp: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    ) {
        self.init(context: context)
        self.id = UUID()
        self.chatId = chat.id
        self.message = message
        self.typeRaw = type.rawValue
        self.senderRaw = sender.rawValue
        self.filePath = file?.path
        self.fileSize = file?.fileSize ?? 0
        self.thumbnailPath = file?.thumbnail?.path
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

    var file: MessageFile? {
        guard let path = filePath else { return nil }
        let resolvedPath = ImageSaver.resolvedPath(path)
        let thumbnail = thumbnailPath.map { MessageThumbnail(path: ImageSaver.resolvedPath($0)) }
        return MessageFile(path: resolvedPath, fileSize: fileSize, thumbnail: thumbnail)
    }
}
