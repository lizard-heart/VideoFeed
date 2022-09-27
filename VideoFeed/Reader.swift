//
//  Reader.swift
//  VideoFeed
//
//  Created by Henry Gustafson on 9/26/22.
//

import Foundation

class Reader: NSObject, XMLParserDelegate {
    
    var parser = XMLParser()
    var feeds = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var ftitle = NSMutableString()
    var link = NSMutableString()
    var img:  [AnyObject] = []
    var fdescription = NSMutableString()
    var fdate = NSMutableString()
    var author = NSMutableString()
    
    // initilise parser
    func initWithURL(_ url :URL) -> AnyObject {
        startParse(url)
        return self
    }
    
    func startParse(_ url :URL) {
        feeds = []
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = false
        parser.shouldResolveExternalEntities = false
        parser.parse()
    }
    

    
    func allFeeds() -> NSMutableArray {
        return feeds
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        element = elementName as NSString
        if (element as NSString).isEqual(to: "entry") {
            elements =  NSMutableDictionary()
            elements = [:]
            ftitle = NSMutableString()
            ftitle = ""
            link = NSMutableString()
            link = ""
            fdescription = NSMutableString()
            fdescription = ""
            fdate = NSMutableString()
            fdate = ""
            author = NSMutableString()
            author = ""
        } else if (element as NSString).isEqual(to: "enclosure") {
            if let urlString = attributeDict["url"] {
                img.append(urlString as AnyObject)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "entry") {
            if ftitle != "" {
                elements.setObject(ftitle, forKey: "media:title" as NSCopying)
            }
            if link != "" {
                elements.setObject(link, forKey: "yt:videoId" as NSCopying)
            }
            if fdescription != "" {
                elements.setObject(fdescription, forKey: "media:description" as NSCopying)
            }
            if fdate != "" {
                elements.setObject(fdate, forKey: "published" as NSCopying)
            }
            if author != "" {
                elements.setObject(author, forKey: "author" as NSCopying)
            }
            feeds.add(elements)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "media:title") {
            ftitle.append(string)
        } else if element.isEqual(to: "yt:videoId") {
            link.append(string)
        } else if element.isEqual(to: "media:description") {
            fdescription.append(string)
        } else if element.isEqual(to: "published") {
            fdate.append(string)
        } else if element.isEqual(to: "author") {
            author.append(string)
        }
    }
}

func feedName(_ url:String) -> String {
    var nameOfFeed = "could not find name"
    var realURL : URL
    realURL = URL(string: url) ?? URL(string: "http://www.youtube.com/feeds/videos.xml?channel_id=UCa6hn-zJEAPxri67W0T35xw")!
        
    
    do {
        try nameOfFeed = String(contentsOf: realURL).components(separatedBy: "title>")[1].components(separatedBy: "<")[0]
    } catch {
        
    }
    return nameOfFeed
}
