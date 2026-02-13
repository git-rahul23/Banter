//
//  ChatDetailView.swift
//  Banter
//
//  Created by RAHUL RANA on 12/02/26.
//

import SwiftUI
import CoreData

struct ChatDetailView: View {

    @Environment(\.managedObjectContext) private var context
    @State private var viewModel: ChatDetailViewModel?
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var showAttachmentSheet = false
    @State private var showFullscreenImage = false
    @State private var fullscreenImageSource: ImageSource?
    @State private var isEditingTitle = false
    @State private var editedTitle = ""

    let chat: Chat

    var body: some View {
        Group {
            if let viewModel {
                chatContent(viewModel: viewModel)
            } else {
                ProgressView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                if let viewModel {
                    Button {
                        editedTitle = viewModel.chat.title ?? ""
                        isEditingTitle = true
                    } label: {
                        Text(viewModel.chat.title ?? "")
                            .font(.headline)
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        .onAppear {
            if viewModel == nil {
                let service = ChatDataService(context: context)
                viewModel = ChatDetailViewModel(chat: chat, dataService: service)
            }
        }
        .alert(String.ChatDetail.editTitle, isPresented: $isEditingTitle) {
            TextField(String.ChatDetail.titlePlaceholder, text: $editedTitle)
            Button(String.Alert.cancel, role: .cancel) { }
            Button(String.Alert.save) {
                viewModel?.updateTitle(editedTitle)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(sourceType: .photoLibrary) { image in
                viewModel?.sendImageMessage(image: image)
            }
        }
        .sheet(isPresented: $showCamera) {
            ImagePickerView(sourceType: .camera) { image in
                viewModel?.sendImageMessage(image: image)
            }
        }
        .fullScreenCover(isPresented: $showFullscreenImage) {
            if let source = fullscreenImageSource {
                FullscreenImageView(imageSource: source)
            }
        }
        .confirmationDialog(String.ChatDetail.attachImage, isPresented: $showAttachmentSheet) {
            Button(String.ChatDetail.photoLibrary) { showImagePicker = true }
            Button(String.ChatDetail.camera) { showCamera = true }
            Button(String.Alert.cancel, role: .cancel) { }
        }
    }

    @ViewBuilder
    private func chatContent(viewModel: ChatDetailViewModel) -> some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 2) {
                        ForEach(viewModel.messages, id: \.objectID) { message in
                            MessageBubbleView(message: message) { source in
                                fullscreenImageSource = source
                                showFullscreenImage = true
                            }
                            .id(message.objectID)
                        }

                        if viewModel.isAgentTyping {
                            TypingIndicatorView()
                                .id("typing-indicator")
                        }
                    }
                    .padding(.horizontal, .Spacing.md)
                    .padding(.top, .Spacing.sm)
                    .padding(.bottom, .Spacing.sm)
                }
                .onChange(of: viewModel.scrollToMessageId) { _, newId in
                    if let id = newId {
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: viewModel.isAgentTyping) { _, isTyping in
                    if isTyping {
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo("typing-indicator", anchor: .bottom)
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        if let lastMessage = viewModel.messages.last {
                            proxy.scrollTo(lastMessage.objectID, anchor: .bottom)
                        }
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if let lastMessage = viewModel.messages.last {
                            withAnimation(.easeOut(duration: 0.25)) {
                                proxy.scrollTo(lastMessage.objectID, anchor: .bottom)
                            }
                        }
                    }
                }
            }

            MessageInputBar(
                text: Binding(
                    get: { viewModel.draftText },
                    set: { viewModel.draftText = $0 }
                ),
                onSend: { viewModel.sendTextMessage() },
                onAttach: { showAttachmentSheet = true }
            )
        }
    }
}

enum ImageSource: Identifiable {
    case url(String)
    case local(String)

    var id: String {
        switch self {
        case .url(let url): return url
        case .local(let path): return path
        }
    }
}
