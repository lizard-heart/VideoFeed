//
//  Constants.swift
//  VideoFeed
//
//  Created by Henry Gustafson on 9/26/22.
//

import Foundation
import UIKit

struct Constants {
    
    static var API_KEY = APIKey.youtubeAPI //replace this with your api key
    static var PLAYLIST_ID = "UU0ZCat9S6KoR7dAiIezBfhg"
    static var API_URL =  "https:www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(Constants.PLAYLIST_ID)&key=\(Constants.API_KEY)"
    static var VIDEOCELL_ID = "VideoCell"
    static var YT_EMBED_URL = "https:www.youtube.com/embed/"
    
    // colors
    static var backgroundColor = UIColor.lightGray
    static var textColor = UIColor.black
}
