//
//  BlogIdea.swift
//  VideoFeed2
//
//  Created by Henry Gustafson on 9/30/21.
//

import Foundation
import CoreData

// ❇️ BlogIdea code generation is turned OFF in the xcdatamodeld file
public class BlogIdea: NSManagedObject, Identifiable {
    @NSManaged public var ideaTitle: String?
    @NSManaged public var ideaDescription: String?
}

extension BlogIdea {
    // ❇️ The @FetchRequest property wrapper in the ContentView will call this function
    static func allIdeasFetchRequest() -> NSFetchRequest<BlogIdea> {
        let request: NSFetchRequest<BlogIdea> = BlogIdea.fetchRequest() as! NSFetchRequest<BlogIdea>
        
        // ❇️ The @FetchRequest property wrapper in the ContentView requires a sort descriptor
        request.sortDescriptors = [NSSortDescriptor(key: "ideaTitle", ascending: true)]
          
        return request
    }
}
