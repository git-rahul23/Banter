//
//  Chat+CoreDataClass.swift
//  Banter
//
//  Created by RAHUL RANA on 12/02/26.
//

import Foundation
import CoreData

@objc(Chat)
public class Chat: NSManagedObject {

    convenience init(context: NSManagedObjectContext, title: String) {
        self.init(context: context)
        self.id = UUID()
        self.title = title
        self.lastMessage = ""
        let now = Int64(Date().timeIntervalSince1970 * 1000)
        self.lastMessageTimestamp = now
        self.createdAt = now
        self.updatedAt = now
    }

    var sortedMessages: [Message] {
        let set = messages as? Set<Message> ?? []
        return set.sorted { $0.timestamp < $1.timestamp }
    }
}
