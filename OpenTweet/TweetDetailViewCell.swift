//
//  TweetDetailView.swift
//  OpenTweet
//
//  Created by Troy Brandt on 12/13/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

class TweetDetailViewCell: UICollectionViewListCell {
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var dateDisplay: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    var tweetCoordinator: TweetDataCoordinator?
    
    func setup() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.tweetCoordinator = appDelegate.tweetCoordinator
        
        self.dateDisplay.textColor = .secondaryLabel
        self.author.textColor = .secondaryLabel
    }
    
    public func updateWithTweet(_ tweet: Tweet) {
        if tweetCoordinator == nil {
            setup()
        }
        var attributes = AttributeContainer()
        attributes.foregroundColor = .secondaryLabel
        let attributedTweet = tweet.attributedContent(withNameAttributes: attributes)
        self.content.attributedText = NSAttributedString(attributedTweet)
        self.content.sizeToFit()
        self.author.text = tweet.author
        
        let formatter = RelativeDateTimeFormatter()
        self.dateDisplay.text = formatter.string(for: tweet.date)
        if let avatarImage = tweet.avatarImage {
            self.avatar.image = avatarImage
        } else {
            self.avatar.image = UIImage(systemName: "person.circle")
        }
    }
}
