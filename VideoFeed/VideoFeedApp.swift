//
//  VideoFeedApp.swift
//  VideoFeed
//
//  Created by Henry Gustafson on 9/26/22.
//

import SwiftUI

@main
struct VideoFeedApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
