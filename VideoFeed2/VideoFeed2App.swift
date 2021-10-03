//
//  VideoFeed2App.swift
//  VideoFeed2
//
//  Created by Henry Gustafson on 9/23/21.
//

import SwiftUI
import CoreData

@main
struct VideoFeed2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(videoID: "sWkHaat0di0")
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
