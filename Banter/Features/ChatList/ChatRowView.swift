//
//  ChatRowView.swift
//  Banter
//
//  Created by RAHUL RANA on 12/02/26.
//

import SwiftUI

struct ChatRowView: View {

    @ObservedObject var chat: Chat

    var body: some View {
        HStack(spacing: .Spacing.md) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: .Size.avatar, height: .Size.avatar)

                Text(avatarText)
                    .font(.system(size: .Size.icon, weight: .semibold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: .Spacing.xs) {
                HStack {
                    Text(chat.title ?? "")
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(1)

                    Spacer()

                    Text(TimestampFormatter.smartFormat(milliseconds: chat.lastMessageTimestamp))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if (chat.lastMessage ?? "").isEmpty {
                    Text(String.ChatList.noMessagesYet)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(Int.LineLimit.chatRow)
                } else {
                    (Text(Image(systemName: isLastMessageFromUser ? String.SystemIcon.userMessage : String.SystemIcon.agentMessage))
                        .font(.caption2)
                        .foregroundColor(isLastMessageFromUser ? .blue : .purple)
                     + Text(" \(chat.lastMessage ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.secondary))
                    .lineLimit(Int.LineLimit.chatRow)
                }
            }
        }
        .padding(.vertical, .Spacing.xs)
    }

    private var isLastMessageFromUser: Bool {
        (chat.lastMessageSender ?? "") == MessageSender.user.rawValue
    }

    private var avatarText: String {
        let title = chat.title ?? ""
        let words = title.split(separator: " ")
        if words.count >= 2 {
            return String(words[0].prefix(1) + words[1].prefix(1)).uppercased()
        }
        return String(title.prefix(2)).uppercased()
    }
}
