//
//  ChatListView.swift
//  Banter
//
//  Created by RAHUL RANA on 12/02/26.
//

import SwiftUI
import CoreData

struct ChatListView: View {

    @Environment(\.managedObjectContext) private var context
    @State private var viewModel: ChatListViewModel?
    @State private var chatToDelete: Chat?
    @State private var showDeleteConfirmation = false
    @State private var navigateToChat: Chat?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    if viewModel.chats.isEmpty {
                        emptyState
                    } else {
                        chatList(viewModel: viewModel)
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Banter")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        createNewChat()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.title3)
                    }
                }
            }
            .navigationDestination(item: $navigateToChat) { chat in
                ChatDetailView(chat: chat)
            }
        }
        .onAppear {
            if viewModel == nil {
                let service = ChatDataService(context: context)
                service.seedDataIfNeeded()
                viewModel = ChatListViewModel(dataService: service)
            } else {
                viewModel?.loadChats()
            }
        }
        .alert("Delete Chat", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let chat = chatToDelete {
                    viewModel?.deleteChat(chat)
                }
            }
        } message: {
            Text("Are you sure you want to delete this chat? This action cannot be undone.")
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            Text("No Conversations Yet")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Tap the compose button to start a new chat")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }

    private func chatList(viewModel: ChatListViewModel) -> some View {
        List {
            ForEach(viewModel.chats, id: \.objectID) { chat in
                ChatRowView(chat: chat)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        navigateToChat = chat
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            chatToDelete = chat
                            showDeleteConfirmation = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
        .listStyle(.plain)
    }

    private func createNewChat() {
        guard let viewModel else { return }
        let chat = viewModel.createNewChat()
        navigateToChat = chat
    }
}
