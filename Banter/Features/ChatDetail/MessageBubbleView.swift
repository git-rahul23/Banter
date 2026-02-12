//
//  MessageBubbleView.swift
//  Banter
//
//  Created by RAHUL RANA on 12/02/26.
//

import SwiftUI

struct MessageBubbleView: View {

    let message: Message
    let onImageTap: (ImageSource) -> Void

    private var isUser: Bool { message.isUser }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isUser { Spacer(minLength: 48) }

            VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
                bubbleContent
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(isUser ? Color.blue : Color(.systemGray5))
                    .foregroundStyle(isUser ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                Text(TimestampFormatter.messageTime(milliseconds: message.timestamp))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
            }

            if !isUser { Spacer(minLength: 48) }
        }
        .padding(.vertical, 2)
    }

    @ViewBuilder
    private var bubbleContent: some View {
        if message.isFile, let filePath = message.filePath {
            VStack(alignment: .leading, spacing: 6) {
                imageContent(path: filePath)

                if let size = message.formattedFileSize {
                    Text(size)
                        .font(.caption)
                        .foregroundStyle(isUser ? .white.opacity(0.7) : .secondary)
                }

                if let text = message.message, !text.isEmpty {
                    Text(text)
                        .font(.body)
                }
            }
        } else {
            Text(message.message ?? "")
                .font(.body)
        }
    }

    @ViewBuilder
    private func imageContent(path: String) -> some View {
        if path.hasPrefix("http") {
            AsyncImage(url: URL(string: path)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 220, maxHeight: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .onTapGesture {
                            onImageTap(.url(path))
                        }
                case .failure:
                    imagePlaceholder(systemName: "photo.badge.exclamationmark")
                case .empty:
                    ProgressView()
                        .frame(width: 220, height: 140)
                @unknown default:
                    imagePlaceholder(systemName: "photo")
                }
            }
        } else {
            if let uiImage = UIImage(contentsOfFile: path) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 220, maxHeight: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onTapGesture {
                        onImageTap(.local(path))
                    }
            } else {
                imagePlaceholder(systemName: "photo.badge.exclamationmark")
            }
        }
    }

    private func imagePlaceholder(systemName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray4))
                .frame(width: 220, height: 140)
            Image(systemName: systemName)
                .font(.title)
                .foregroundStyle(.secondary)
        }
    }
}
