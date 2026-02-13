//
//  BanterApp.swift
//  Banter
//
//  Created by RAHUL RANA on 12/02/26.
//

import SwiftUI

@main
struct BanterApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let context = persistenceController.container.viewContext
            let dataService = ChatDataService(context: context)

            ChatListView(dataService: dataService)
                .environment(\.managedObjectContext, context)
                .onAppear {
                    dataService.seedDataIfNeeded()
                }
        }
    }
}
