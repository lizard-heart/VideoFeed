//
//  YoutubeModel.swift
//  VideoFeed
//
//  Created by Henry Gustafson on 9/26/22.
//

import Foundation

struct Items: Decodable {
    let items: [Channel]
}

struct Channel: Decodable, Identifiable {
    var id: String {
        return etag
    }
    let etag: String
    let snippet: Snippet
}

struct Snippet: Decodable {
    let title: String?
    let description: String?
    let channelId: String?
    let thumbnails: Thumbnails
}


struct Thumbnails: Decodable {
    let high: High
}

struct High: Decodable {
    let url: String?
}

struct URLName {
    let partialURL = "https://youtube.googleapis.com/youtube/v3/search?part=snippet&type=channel&q="
    var searchTerm: String = ""
    var searchTermState: String = ""
    let apiKey = "&key="+Constants.API_KEY
}
