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
            ChatListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
