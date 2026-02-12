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
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Text("Setup")
                .font(.title)
                .navigationTitle("Banter")
        }
    }
}
