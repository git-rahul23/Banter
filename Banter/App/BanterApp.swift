//
//  BanterApp.swift
//  Banter
//
//  Created by RAHUL RANA on 12/02/26.
//

import SwiftUI

@main
struct BanterApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
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
