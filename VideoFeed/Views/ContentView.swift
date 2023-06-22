//
//  ContentView.swift
//  VideoFeed
//
//  Created by Henry Gustafson on 9/26/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.channelID, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var showAddPlaylist = false
    @State var showAddChannel = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Feeds")
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(Color.red)

                List {
                    Section(header: Text("Smart Feeds")) {
                        NavigationLink {
                            VideoFeed(channelID: "1", isPlaylist: true)
                        } label: {
                            Text("All Feeds").fontWeight(.bold)
                        }
                    }
                    
                    Section(header: Text("Channels")) {
                        ForEach(items) { item in
                            NavigationLink {
                                VideoFeed(channelID: item.channelID!, isPlaylist: false)
                            } label: {
                                Text(item.name!)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }

                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                    ToolbarItem {
                        Button(action: {
                            self.showAddChannel = true
                        }) {
                            Label("Add Channel", systemImage: "plus")
                        }
//                        NavigationLink(destination: NewChannelView()) {
//                            Label("Add Item", systemImage: "plus")
//                        }
                    }
//                    ToolbarItem{
//                        NavigationLink(destination: AddPlaylist()) {
//                            Label("Add Playlist", systemImage: "text.badge.plus")
//                        }
//                    }
                }

            }
            .navigationBarItems(trailing: Button(action: {
                self.showAddPlaylist = true
            }) {
                Label("Add Playlist", systemImage: "text.badge.plus")
            })
            .sheet(isPresented: $showAddChannel, content: {
                                    NewChannelView()
                                })
            .sheet(isPresented: $showAddPlaylist, content: {
                                AddPlaylist()
                            })
            
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.channelID = "test"

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
