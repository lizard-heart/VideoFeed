//
//  ContentView.swift
//  VideoFeed2
//
//  Created by Henry Gustafson on 9/23/21.
//

import SwiftUI
import WebKit
import CoreData

//Homepage
struct ContentView: View {

    @State private var showingAlert = false
    @State private var textEntered = ""
    @State private var youtubeChannel = ""
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Item.entity(), sortDescriptors: []) var items: FetchedResults<Item>
    @FetchRequest(entity: Item2.entity(), sortDescriptors: []) var channels: FetchedResults<Item2>
    
    var videoID: String
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    
                    NavigationLink(destination: VideoFeed()) {
                        Text("Show Main Video Feed")
                    }.navigationBarTitle("Home", displayMode: .inline)
                        .onAppear(perform: {
                            removeWatchedVideos(watchedVideos: items, subscribedFeeds: channels)
                        })
                    
                    List {
                        ForEach(channels, id:\.id) { channel in
                            Text(feedName(channel.channelID!))
                        }.onDelete(perform: delete)
                        
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button("Add Channel") {
                            print("alert should pop up now")
                            self.showingAlert.toggle()
                            print(self.textEntered)
                        }

                        Spacer()
                        
                        Button("Import", action: {
                        })
                        
                        Spacer()
                    }.padding()
                }
                CustomAlert(textEntered: $textEntered, showingAlert: $showingAlert)
                    .opacity(showingAlert ? 1 : 0)
            }.background(Color(red: 0/256, green: 0/256, blue: 0/256))
        }.preferredColorScheme(.dark)
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let channel = channels[index]
            viewContext.delete(channel)
            try? self.viewContext.save()
        }
    }
}

//main video feed page
struct VideoFeed: View {
    var body: some View {
        VStack {
            Text("Video Feed")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.red)

            Text("Your main feed of all new videos")
            
            List {
                ForEach(listOfVideos) { video in
                    HStack {
                        VStack (alignment: .leading) {
                            NavigationLink(destination: VideoPlayerView(videoID: video.id.components(separatedBy: "\n")[0])) {
                                Text(video.videoTitle)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.gray)
                            }
                            
                            Text(video.author)
                                .font(.caption)
                        }.onAppear(perform: {
                            print(video.id.components(separatedBy: "\n")[0])
                        })
                    }
                }
            }
        }
    }
}

//video that plays youtube video
struct VideoPlayerView: View {
    var videoID :String
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Item.entity(), sortDescriptors: []) var items: FetchedResults<Item>
    @FetchRequest(entity: Item2.entity(), sortDescriptors: []) var channels: FetchedResults<Item2>

    var body: some View {
        let webViewModel = WebViewModel(url: "https://www.youtube.com/watch?v=" + videoID)
        NavigationView {
            ZStack {
                WebViewContainer(webViewModel: webViewModel)
                if webViewModel.isLoading {
                    
                }
            }.onAppear{
                let watchedVideo = Item(context: viewContext)
                watchedVideo.videoID = videoID
                try? self.viewContext.save()
                
                // update the listofvideos variable
                for item in items {
                    videosToRemove.append(item.videoID!)
                }

                for channel in channels {
                    loadRss((URL(string: channel.channelID!) ?? URL(string: "http://www.youtube.com/feeds/videos.xml?channel_id=UCa6hn-zJEAPxri67W0T35xw")!))
                }
                var indicesToRemove:[Int] = []
                for n in 0..<listOfVideos.count {
                    let realIDToCheck = listOfVideos[n].id.components(separatedBy: "\n")[0]
                    if videosToRemove.contains(realIDToCheck){
                        print(n)
                        print(listOfVideos[n].videoTitle)
                        indicesToRemove.append(n)
                    }

                }
                indicesToRemove.sort()
                for i in 0..<indicesToRemove.count {
                    listOfVideos.remove(at: indicesToRemove[i])
                    if i + 1 < indicesToRemove.count {
                        indicesToRemove[i+1] = indicesToRemove[i+1]-i-1
                    }
                }
            }
            .navigationBarTitle(Text(webViewModel.title), displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                webViewModel.shouldGoBack.toggle()
            }, label: {
                if webViewModel.canGoBack {
                    Image(systemName: "arrow.left")
                        .frame(width: 44, height: 44, alignment: .center)
                        .foregroundColor(.black)
                } else {
                    EmptyView()
                        .frame(width: 0, height: 0, alignment: .center)
                }
            }))
        }
    }
}

//custom alert for adding feed
struct CustomAlert: View {
    @Binding var textEntered: String
    @Binding var showingAlert: Bool
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Item2.entity(), sortDescriptors: []) var channels:
        FetchedResults<Item2>
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.1, green: 0.1, blue: 0.1))
            VStack {
                Text("Add Channel")
                    .font(.title)
                    .foregroundColor(.white)
                
                TextField("Paste YouTube channel URL here", text: $textEntered)
                    .padding(5)
                    .background(Color.gray.opacity(0.3))
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                    .keyboardType(.URL)
                                
                HStack {
                    Button("Enter") {
                        if feedName(self.textEntered) != "Henry Gustafson___" {
                            let channel = Item2(context: viewContext)
                            channel.channelID = self.textEntered
                            try? self.viewContext.save()
                        } else {
                            
                        }

                        loadRss((URL(string: self.textEntered) ?? URL(string: "http://www.youtube.com/feeds/videos.xml?channel_id=UCa6hn-zJEAPxri67W0T35xw")!))
                        self.textEntered = ""
                        self.showingAlert.toggle()
                    }
                    Spacer()
                    Button("Cancel") {
                        self.textEntered = ""
                        self.showingAlert.toggle()
                    }
                }
                .padding(30)
                .padding(.horizontal, 40)
            }
        }
        .frame(width: 300, height: 200)
    }
}

//Web view stuff
class WebViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var canGoBack: Bool = false
    @Published var shouldGoBack: Bool = false
    @Published var title: String = ""
    
    var url: String
    
    init(url: String) {
        self.url = url
    }
}

struct WebViewContainer: UIViewRepresentable {
    @ObservedObject var webViewModel: WebViewModel
    
    func makeCoordinator() -> WebViewContainer.Coordinator {
        Coordinator(self, webViewModel)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.webViewModel.url) else {
            return WKWebView()
        }
        
        let request = URLRequest(url: url)
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if webViewModel.shouldGoBack {
            uiView.goBack()
            webViewModel.shouldGoBack = false
        }
    }
}

extension WebViewContainer {
    class Coordinator: NSObject, WKNavigationDelegate {
        @ObservedObject private var webViewModel: WebViewModel
        private let parent: WebViewContainer
        
        init(_ parent: WebViewContainer, _ webViewModel: WebViewModel) {
            self.parent = parent
            self.webViewModel = webViewModel
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            webViewModel.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webViewModel.isLoading = false
            webViewModel.title = webView.title ?? ""
            webViewModel.canGoBack = webView.canGoBack
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            webViewModel.isLoading = false
        }
    }
}

//Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(videoID: "eGnH0KAXhCw")
.previewInterfaceOrientation(.portrait)
    }
}
