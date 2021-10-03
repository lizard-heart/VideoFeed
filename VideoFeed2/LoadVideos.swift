//
//  LoadVideos.swift
//  VideoFeed2
//
//  Created by Henry Gustafson on 10/3/21.
//

import Foundation
import SwiftUI

var videoTitles: NSArray = []
var videoIDs: NSArray = []
var videoAuthors: NSArray = []
var feedAuthor = ""
struct Video: Identifiable {
    var id : String
    let videoTitle, author: String
}
var listOfVideos:[Video] = []
var videosToRemove: [String] = []

//append videos from a feed to listOfVideos
func loadRss(_ data: URL) {
    let reader: Reader = Reader().initWithURL(data) as! Reader
    videoTitles = reader.feeds.mutableArrayValue(forKey: "media:title")
    videoIDs = reader.feeds.mutableArrayValue(forKey: "yt:videoId")
    videoAuthors = reader.feeds.mutableArrayValue(forKey: "author")
    for i in videoTitles {
        let intIndex = videoTitles.index(of: i)
        var videoTitleString = videoTitles[intIndex] as! String
        if videoTitleString.contains("\n") {
            videoTitleString = videoTitleString.components(separatedBy: "\n")[0]
        }
        let videoToAppend = Video(id: videoIDs[intIndex] as! String, videoTitle: videoTitleString, author: feedAuthor)
        var listOfVideoIDs:[String] = []
        for i in listOfVideos {
            listOfVideoIDs.append(i.id)
        }
        if listOfVideoIDs.contains(videoToAppend.id) == false {
            listOfVideos.append(videoToAppend)
        }
    }
}

//loadRss for all feeds and then remove watched videos
func removeWatchedVideos(watchedVideos: FetchedResults<Item>, subscribedFeeds: FetchedResults<Item2>) {
    for item in watchedVideos {
        videosToRemove.append(item.videoID!)
    }

    for channel in subscribedFeeds {
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
