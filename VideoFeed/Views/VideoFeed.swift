//
//  VideoFeed.swift
//  VideoFeed
//
//  Created by Henry Gustafson on 9/26/22.
//

import SwiftUI

struct VideoFeed: View {
    var channelID: String
    var isPlaylist: Bool
    
    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \WatchedVideos.videoID, ascending: true)],
//        animation: .default)
    @FetchRequest(entity: Item.entity(), sortDescriptors: []) var subscribedFeeds: FetchedResults<Item>
    @FetchRequest(entity: WatchedVideos.entity(), sortDescriptors: []) var watchedVideos: FetchedResults<WatchedVideos>
    
    var body: some View {
        List {
//            ForEach(loadRss(URL(string: "http://www.youtube.com/feeds/videos.xml?channel_id=" + channelID)!)) { video in
//                VStack(alignment: .leading) {
//                    Text(video.videoTitle)
//                    Text(video.author)
//                }
//            }
            ForEach(generateVideoList(isPlaylist: isPlaylist, ID: channelID, watchedVideos: watchedVideos, subscribedFeeds: subscribedFeeds)) { video in
                VStack(alignment: .leading) {
                    NavigationLink {
                        VideoPlayer(videoID: video.id, videoTitle: video.videoTitle, videoDescription: video.description)
                    } label: {
                        Text(video.videoTitle)
                    }
                    subTitle(isPlaylist: isPlaylist, video: video)
                }
            }
        }
    }
}

//struct VideoFeed_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoFeed(channelID: "UCSju5G2aFaWMqn-_0YBtq5A")
//    }
//}

struct Video: Identifiable {
    var id: String
    let videoTitle: String
    var author: String
    var published: String
    var description: String
}

func loadRss(_ data: URL) -> [Video] {
    let reader: Reader = Reader().initWithURL(data) as! Reader
    let videoTitles = reader.feeds.mutableArrayValue(forKey: "media:title")
    let videoIDs = reader.feeds.mutableArrayValue(forKey: "yt:videoId")
    let publishDates = reader.feeds.mutableArrayValue(forKey: "published")
    let descriptions = reader.feeds.mutableArrayValue(forKey: "media:description")
    var videoAuthors = ""
    
    do {
        try videoAuthors = String(contentsOf: data).components(separatedBy: "title>")[1].components(separatedBy: "<")[0]
    } catch {
        
    }
    
    var videosToReturn: [Video] = []
    
    for i in videoTitles {
        let intIndex = videoTitles.index(of: i)
        var videoTitleString = videoTitles[intIndex] as! String
        let description = descriptions[intIndex] as! String
        let publishDate = publishDates[intIndex] as! String
//        var videoAuthorString = videoAuthors[intIndex] as! String
        if videoTitleString.contains("\n") {
            videoTitleString = videoTitleString.components(separatedBy: "\n")[0]
        }
        videosToReturn.append(Video(id: (videoIDs[intIndex] as! String).components(separatedBy: "\n")[0], videoTitle: videoTitleString, author: videoAuthors, published: publishDate, description: description))
    }
    
    return videosToReturn
}

//loadRss for all feeds and then remove watched videos
func removeWatchedVideos(watchedVideos: FetchedResults<WatchedVideos>, subscribedFeeds: [String]) -> [Video] {
    var videosToRemove:[String] = []
    var allVideos:[Video] = []
    for item in watchedVideos {
        videosToRemove.append(item.videoID!)
    }

    for channel in subscribedFeeds {
        let tempVids = loadRss((URL(string: "http://www.youtube.com/feeds/videos.xml?channel_id=" + channel) ?? URL(string: "http://www.youtube.com/feeds/videos.xml?channel_id=UCa6hn-zJEAPxri67W0T35xw")!))
        for vid in tempVids {
            allVideos.append(vid)
        }
    }
    var indicesToRemove:[Int] = []
    for n in 0..<allVideos.count {
        let realIDToCheck = allVideos[n].id.components(separatedBy: "\n")[0]
        if videosToRemove.contains(realIDToCheck){
            indicesToRemove.append(n)
        }
    }
    indicesToRemove.sort()
    for i in 0..<indicesToRemove.count {
        allVideos.remove(at: indicesToRemove[i])
        if i + 1 < indicesToRemove.count {
            indicesToRemove[i+1] = indicesToRemove[i+1]-i-1
        }
    }
    return allVideos
}

func generateVideoList(isPlaylist: Bool, ID: String, watchedVideos: FetchedResults<WatchedVideos>, subscribedFeeds: FetchedResults<Item>) -> [Video] {
    if isPlaylist == true {
        if ID == "1" {
            var channelIDs: [String] = []
            for channel in subscribedFeeds {
                channelIDs.append(channel.channelID!)
            }
            return removeWatchedVideos(watchedVideos: watchedVideos, subscribedFeeds: channelIDs)
        } else {
            //temporary
            return removeWatchedVideos(watchedVideos: watchedVideos, subscribedFeeds: [ID])
        }
    } else {
        return removeWatchedVideos(watchedVideos: watchedVideos, subscribedFeeds: [ID])
    }
}

func subTitle(isPlaylist: Bool, video: Video) -> Text {
    if isPlaylist == true {
        return Text(video.author).foregroundColor(Color.red)
    } else {
        return Text(video.published.components(separatedBy: "T")[0])
    }
}
