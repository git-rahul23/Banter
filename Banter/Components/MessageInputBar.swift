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
    let onPhotoLibrary: () -> Void
    let onCamera: () -> Void

    @FocusState private var isFocused: Bool
    @State private var showAttachmentSheet = false

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(alignment: .bottom, spacing: .Spacing.sm) {
                Button { showAttachmentSheet = true } label: {
                    Image(systemName: String.SystemIcon.attach)
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
                .padding(.bottom, 6)
                .confirmationDialog(String.ChatDetail.attachImage, isPresented: $showAttachmentSheet) {
                    Button(String.ChatDetail.photoLibrary) { onPhotoLibrary() }
                    Button(String.ChatDetail.camera) { onCamera() }
                    Button(String.Alert.cancel, role: .cancel) { }
                }

                TextField(String.ChatDetail.messageInputPlaceholder, text: $text, axis: .vertical)
                    .textFieldStyle(.plain)
                    .lineLimit(Int.LineLimit.messageInputMin...Int.LineLimit.messageInputMax)
                    .padding(.horizontal, .Spacing.md)
                    .padding(.vertical, .Spacing.sm)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: .Radius.xxl))
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
