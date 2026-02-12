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
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)

                Text(avatarText)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(chat.title ?? "")
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(1)

                    Spacer()

                    Text(TimestampFormatter.smartFormat(milliseconds: chat.lastMessageTimestamp))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                let preview = (chat.lastMessage ?? "").isEmpty ? "No messages yet" : (chat.lastMessage ?? "")
                Text(preview)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
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
