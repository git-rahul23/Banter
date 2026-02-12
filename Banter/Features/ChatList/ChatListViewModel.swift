//
//  ChatListViewModel.swift
//  Banter
//
//  Created by RAHUL RANA on 12/02/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class ChatListViewModel {

    private let dataService: ChatDataService
    var chats: [Chat] = []

    init(dataService: ChatDataService) {
        self.dataService = dataService
        loadChats()
    }

    func loadChats() {
        chats = dataService.fetchAllChats()
    }

    func createNewChat() -> Chat {
        let chat = dataService.createChat(title: "New Chat")
        loadChats()
        return chat
    }

    func deleteChat(_ chat: Chat) {
        dataService.deleteChat(chat)
        loadChats()
    }
}
