//
//  ChatListViewModel.swift
//  Banter
//
//  Created by RAHUL RANA on 12/02/26.
//

import Foundation
import CoreData
import Combine

@MainActor
final class ChatListViewModel: NSObject, ObservableObject {

    private let dataService: ChatDataService
    @Published var chats: [Chat] = []

    private var fetchedResultsController: NSFetchedResultsController<Chat>?

    init(dataService: ChatDataService) {
        self.dataService = dataService
        super.init()
        setupFetchedResultsController()
        loadChats()
    }

    private func setupFetchedResultsController() {
        let request: NSFetchRequest<Chat> = Chat.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "lastMessageTimestamp", ascending: false)]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: dataService.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        fetchedResultsController?.delegate = self
    }

    func loadChats() {
        try? fetchedResultsController?.performFetch()
        chats = fetchedResultsController?.fetchedObjects ?? []
    }

    func createNewChat() -> Chat {
        let chat = dataService.createChat(title: String.ChatList.newChatTitle)
        return chat
    }

    func deleteChat(_ chat: Chat) {
        dataService.deleteChat(chat)
    }
}

extension ChatListViewModel: NSFetchedResultsControllerDelegate {
    nonisolated func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        Task { @MainActor in
            chats = fetchedResultsController?.fetchedObjects ?? []
        }
    }
}
