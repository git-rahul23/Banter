//
//  Constants.swift
//  Banter
//
//  Created by RAHUL RANA on 13/02/26.
//

import SwiftUI

// MARK: - Strings
extension String {
    
    enum App {
        static let title = "Banter"
    }
    
    enum ChatList {
        static let emptyStateTitle = "No Conversations Yet"
        static let emptyStateMessage = "Tap the compose button to start a new chat"
        static let newChatTitle = "New Chat"
        static let noMessagesYet = "No messages yet"
    }
    
    enum ChatDetail {
        static let editTitle = "Edit Chat Title"
        static let titlePlaceholder = "Chat title"
        static let attachImage = "Attach Image"
        static let photoLibrary = "Photo Library"
        static let camera = "Camera"
        static let imageChatTitle = "Image Chat"
        static let sentAnImage = "Sent an image"
        static let messageInputPlaceholder = "Type a message..."
    }
    
    enum Alert {
        static let deleteChat = "Delete Chat"
        static let deleteChatMessage = "Are you sure you want to delete this chat? This action cannot be undone."
        static let cancel = "Cancel"
        static let delete = "Delete"
        static let save = "Save"
    }
    
    enum Error {
        static let failedToLoadImage = "Failed to load image"
    }
    
}

// MARK: - System Images
extension String {
    
    enum SystemIcon {
        static let compose = "square.and.pencil"
        static let delete = "trash"
        static let close = "xmark.circle.fill"
        
        static let emptyState = "bubble.left.and.bubble.right"
        
        static let userMessage = "arrow.turn.up.right"
        static let agentMessage = "sparkles"
        static let attach = "plus.circle.fill"
        static let send = "arrow.up.circle.fill"
        
        static let imageError = "photo.badge.exclamationmark"
    }
    
}

// MARK: - Layout
extension CGFloat {
    
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 40
    }
    
    enum Radius {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
    }
    
    enum Size {
        static let avatarSm: CGFloat = 32
        static let avatar: CGFloat = 48
        static let avatarLg: CGFloat = 64
        static let icon: CGFloat = 18
        static let iconLg: CGFloat = 24
    }
    
}

// MARK: - Line Limits
extension Int {
    
    enum LineLimit {
        static let messageInputMin = 1
        static let messageInputMax = 5
        static let chatRow = 2
        static let single = 1
    }
    
}

// MARK: - Animation
extension Double {
    
    enum Animation {
        static let fast: Double = 0.2
        static let standard: Double = 0.3
        static let slow: Double = 0.5
    }
    
}
