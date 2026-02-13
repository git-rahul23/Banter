//
//  MessageInputBar.swift
//  Banter
//
//  Created by RAHUL RANA on 12/02/26.
//

import SwiftUI

struct MessageInputBar: View {

    @Binding var text: String
    let onSend: () -> Void
    let onAttach: () -> Void

    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(alignment: .bottom, spacing: .Spacing.sm) {
                Button(action: onAttach) {
                    Image(systemName: String.SystemIcon.attach)
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
                .padding(.bottom, 6)

                TextField(String.ChatDetail.messageInputPlaceholder, text: $text, axis: .vertical)
                    .textFieldStyle(.plain)
                    .lineLimit(Int.LineLimit.messageInputMin...Int.LineLimit.messageInputMax)
                    .padding(.horizontal, .Spacing.md)
                    .padding(.vertical, .Spacing.sm)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: .Radius.xl))
                    .focused($isFocused)

                Button {
                    onSend()
                } label: {
                    Image(systemName: String.SystemIcon.send)
                        .font(.title2)
                        .foregroundStyle(canSend ? .blue : .gray)
                }
                .disabled(!canSend)
                .padding(.bottom, 6)
            }
            .padding(.horizontal, .Spacing.md)
            .padding(.vertical, .Spacing.sm)
            .background(.bar)
        }
    }

    private var canSend: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
