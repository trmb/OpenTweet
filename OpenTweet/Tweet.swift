//
//  Tweet.swift
//  OpenTweet
//
//  Created by Troy Brandt on 12/13/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

struct Tweet: Hashable {
    let id: Int
    let author: String
    let content: String
    let avatarUrl: URL?
    let date: Date
    let replyId: Int?
    
    var avatarImage: UIImage? {
        if let avatarUrl = avatarUrl {
            do {
                // TODO: This needs to be cached
                let data = try Data(contentsOf: avatarUrl)
                return UIImage(data: data)
            } catch {
                // We can just fall thrugh and return nil
            }
        }
        return nil
    }
    
    /// Parse content string and apply `nameAttributes` to any name mentions matching the `@username` format.
    public func attributedContent(withNameAttributes nameAttributes: AttributeContainer) -> AttributedString {
        var attributedStr = AttributedString(content)
        do {
            let usernamePattern = #"(@[0-9a-zA-Z_]+)|(http[a-zA-Z0-9.://=?]+)"#
            let regex = try NSRegularExpression(pattern: usernamePattern, options: [])
            let nsrange = NSRange(attributedStr.startIndex..<attributedStr.endIndex,
                                  in: attributedStr)
            regex.enumerateMatches(in: content,
                                   options: [],
                                   range: nsrange) { (match, _, stop) in
                guard let match = match else { return }
                if let nameCaptureRange = Range(match.range(at: 1), in: attributedStr) {
                    attributedStr[nameCaptureRange].setAttributes(nameAttributes)
                }
                
                if let linkCaptureRange = Range(match.range(at: 2), in: attributedStr) {
                    
                    let link = String(attributedStr[linkCaptureRange].characters)
                    let url = URL(string: link)
                    var linkAttributes = AttributeContainer()
                    linkAttributes.foregroundColor = .link
                    linkAttributes.link = url
                    attributedStr[linkCaptureRange].setAttributes(linkAttributes)
                }
            }
        } catch {
            print("There was a problem parsing content: \(error)")
        }
        return attributedStr
    }
}

extension Tweet: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case author = "author"
        case content = "content"
        case avatarUrl = "avatar"
        case date = "date"
        case replyId = "inReplyTo"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        author = try values.decode(String.self, forKey: .author)
        content = try values.decode(String.self, forKey: .content)
        
        // Convert ids
        let idString = try values.decode(String.self, forKey: .id)
        let replyIdString = try values.decodeIfPresent(String.self, forKey: .replyId)

        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en-US")
        if let idNum = numberFormatter.number(from: idString) {
            id = idNum.intValue
        } else {
            throw DecodingError.dataCorruptedError(forKey: .id, in: values, debugDescription: "Unable to decode value for id \(idString)")
        }
        
        if let replyIdString = replyIdString {
            if let replyIdNum = numberFormatter.number(from: replyIdString) {
                replyId = replyIdNum.intValue
            } else {
                throw DecodingError.dataCorruptedError(forKey: .replyId, in: values, debugDescription: "Unable to decode value for id \(replyIdString)")
            }
        } else {
            replyId = nil
        }
        
        // Convert date
        let dateString = try values.decode(String.self, forKey: .date)
        let dateFormatter = ISO8601DateFormatter()
        if let d = dateFormatter.date(from:dateString) {
            date = d
        } else {
            date = Date() // This should probably be handled differently
        }
        
        // Avatar URL
        if let avatarUrlString = try values.decodeIfPresent(String.self, forKey: .avatarUrl) {
            avatarUrl = URL(string: avatarUrlString)
        } else {
            avatarUrl = nil
        }
    }

}

struct TweetData: Codable {
    var timeline: [Tweet]
}
