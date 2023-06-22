//
//  NewChannelView.swift
//  VideoFeed
//
//  Created by Henry Gustafson on 9/26/22.
//

import SwiftUI
import CoreData

struct NewChannelView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.channelID, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @ObservedObject var networkManager = NetworkManager()
    @State var textFieldContent: String = ""
    @State var tempChanges = 0
//    @State var showingAlert: Bool
    @State var swipeInstructions = ""
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
            VStack {
                Text("Add Channel")
                    .padding()
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(Color.red)
                HStack {
                    
                    
                    TextField("search", text: $textFieldContent)
                        .border(Color(red: 0.50, green: 0.67, blue: 0.48, opacity: 0.00))
                        .frame(width: 200)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(10)
                        .font(Font.system(size: 15, weight: .medium))
                        .onChange(of: textFieldContent, perform: { value in
                            Task.init {
                                if !value.isEmpty && value.count > 3 && tempChanges > 1 {
                                    swipeInstructions = "swipe to subscribe"
                                    tempChanges = 0
                                    networkManager.fetchSearch(searchTerm: textFieldContent)
                                    networkManager.useThisURL = "\(URLName().partialURL)\(textFieldContent)\(URLName().apiKey)"
                                    networkManager.fetchData()
                                } else {
                                    if value.isEmpty || value.count < 4 {
                                        networkManager.channels.removeAll()
                                    }
                                    tempChanges += 1
                                }
                            }
                        })
                    
                    Button(action: {
                        networkManager.fetchSearch(searchTerm: textFieldContent)
                        networkManager.useThisURL = "\(URLName().partialURL)\(textFieldContent)\(URLName().apiKey)"
                        networkManager.fetchData()
                        textFieldContent = ""
                        UIApplication.shared.endEditing()
                        
                    }) {
                        Text("")
                            .foregroundColor(Color(red: 0.50, green: 0.67, blue: 0.48, opacity: 1.00))
                            .font(Font.system(size: 20))
                        Image(systemName: "magnifyingglass.circle.fill")
                            .foregroundColor(Color(UIColor.red))
                            .font(.largeTitle)
                            .aspectRatio(contentMode: .fit)
                    }
                    
                }
                //            Text(swipeInstructions)
                List(networkManager.channels){ channel in
                    HStack {
                        Button(action: {
                            print(channel.snippet.channelId ?? "")
                            let newChannel = Item(context: viewContext)
                            newChannel.channelID = channel.snippet.channelId
                            newChannel.name = channel.snippet.title
                            
                            do {
                                try viewContext.save()
                                self.dismiss()
                            } catch {
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                            
                        }) {
                            Label("", systemImage: "plus")
                        }
                        
                        VStack {
                            Text(String("\(channel.snippet.title ?? "" ):")).bold()
                            Text(String("\(channel.snippet.description ?? "")"))
                            //                    Text(String("The channelID is: \(channel.snippet.channelId ?? "")")).foregroundColor(Color(.systemMint))
                            
                            
                            
                            
                        }
                    }
                    //                .swipeActions {
                    //                    Button(action: {
                    //                        print(channel.snippet.channelId ?? "")
                    //                        let newChannel = Item(context: viewContext)
                    //                        newChannel.channelID = channel.snippet.channelId
                    //                        newChannel.name = channel.snippet.title
                    //
                    //                        do {
                    //                            try viewContext.save()
                    //                        } catch {
                    //                            let nsError = error as NSError
                    //                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    //                        }
                    //
                    //                    }) {
                    //                        Label("Subscribe", systemImage: "plus")
                    //                    }
                    //                }
                }
            }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
