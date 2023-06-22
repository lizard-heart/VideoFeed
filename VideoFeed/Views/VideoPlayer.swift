//
//  VideoPlayer.swift
//  VideoFeed
//
//  Created by Henry Gustafson on 9/26/22.
//

import SwiftUI
import WebKit
import CoreData

struct VideoPlayer: View {
    @Environment(\.managedObjectContext) private var viewContext
    var videoID: String
    var videoTitle: String
    var videoDescription: String
    var body: some View {
        VStack {
            Text(videoTitle)
                .fontWeight(.bold)
                .font(.title)
                .foregroundColor(Color.red)
            
            Spacer()
            
            VStack {
                let webViewModel = WebViewModel(url: Constants.YT_EMBED_URL + videoID)
                WebViewContainer(webViewModel: webViewModel)
            }
            .frame(width:UIScreen.main.bounds.width, height: 9/16*UIScreen.main.bounds.width)
            .onAppear(perform: {
                let watchedVideo = WatchedVideos(context: viewContext)
                watchedVideo.videoID = videoID
                
                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
                print(videoID)
            })
            
            Text(videoDescription)
            
            Spacer()
        }
    }
}

struct VideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayer(videoID: "_TbumHgezdI", videoTitle: "title", videoDescription: "description")
    }
}
