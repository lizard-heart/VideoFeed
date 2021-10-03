//
//  PersistanceController.swift
//  VideoFeed2
//
//  Created by Henry Gustafson on 9/30/21.
//

import Foundation
struct PersistenceController {
    // A singleton for our entire app to use
    static let shared = PersistenceController()

    // Storage for Core Data
    let container: NSPersistentContainer

    // A test configuration for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)

        // Create 10 example programming languages.
        for _ in 0..<10 {
            let language = Channels(context: controller.container.viewContext)
            language.youtubeChannel = "Example Language 1"
            language.creator = "A. Programmer"
        }

        return controller
    }()

    // An initializer to load Core Data, optionally able
    // to use an in-memory store.
    init(inMemory: Bool = false) {
        // If you didn't name your model Main you'll need
        // to change this name below.
        container = NSPersistentContainer(name: "Videos")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}

func save() {
    let context = container.viewContext

    if context.hasChanges {
        do {
            try context.save()
        } catch {
            // Show some error here
        }
    }
}
