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
                        chatList
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle(String.App.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        createNewChat()
                    } label: {
                        Image(systemName: String.SystemIcon.compose)
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
            }
        }
        .alert(String.Alert.deleteChat, isPresented: $showDeleteConfirmation) {
            Button(String.Alert.cancel, role: .cancel) { }
            Button(String.Alert.delete, role: .destructive) {
                if let chat = chatToDelete {
                    viewModel?.deleteChat(chat)
                }
            }
        } message: {
            Text(String.Alert.deleteChatMessage)
        }
    }

    private var emptyState: some View {
        VStack(spacing: .Spacing.lg) {
            Image(systemName: String.SystemIcon.emptyState)
                .font(.system(size: .Size.avatarLg))
                .foregroundStyle(.secondary)
            Text(String.ChatList.emptyStateTitle)
                .font(.title2)
                .fontWeight(.semibold)
            Text(String.ChatList.emptyStateMessage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.Spacing.xxl)
    }

    private var chatList: some View {
        List {
            ForEach(viewModel?.chats ?? [], id: \.objectID) { chat in
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
                            Label(String.Alert.delete, systemImage: String.SystemIcon.delete)
                        }
                        .tint(.red)
                    }
                    .listRowBackground(Color.clear)
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
