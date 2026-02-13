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
        HStack(alignment: .bottom, spacing: .Spacing.sm) {
            if isUser { Spacer(minLength: .Size.messageBubbleMinWidth) }

            VStack(alignment: isUser ? .trailing : .leading, spacing: .Spacing.xs) {
                bubbleContent
                    .padding(.horizontal, .Spacing.md)
                    .padding(.vertical, .Spacing.sm)
                    .background(isUser ? Color.blue : Color(.systemGray5))
                    .foregroundStyle(isUser ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: .Radius.xl))

                Text(TimestampFormatter.messageTime(milliseconds: message.timestamp))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, .Spacing.xs)
            }

            if !isUser { Spacer(minLength: .Size.messageBubbleMinWidth) }
        }
        .padding(.vertical, 2)
    }

    @ViewBuilder
    private var bubbleContent: some View {
        if message.isFile, let file = message.file {
            VStack(alignment: .leading, spacing: .Spacing.xs) {
                imageContent(file: file)

                if let size = file.formattedFileSize {
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
    private func imageContent(file: MessageFile) -> some View {
        let displayPath = file.thumbnail?.path ?? file.path
        if let uiImage = UIImage(contentsOfFile: displayPath) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .Size.imageMaxWidth, maxHeight: .Size.imageMaxHeight)
                .clipShape(RoundedRectangle(cornerRadius: .Radius.md))
                .onTapGesture {
                    onImageTap(.local(file.path))
                }
        } else {
            imagePlaceholder(systemName: String.SystemIcon.imageError)
        }
    }

    private func imagePlaceholder(systemName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: .Radius.md)
                .fill(Color(.systemGray4))
                .frame(width: .Size.imageMaxWidth, height: .Size.imagePlaceholderHeight)
            Image(systemName: systemName)
                .font(.title)
                .foregroundStyle(.secondary)
        }
    }
}
