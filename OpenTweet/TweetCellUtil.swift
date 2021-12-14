//
//  TweetCellUtil.swift
//  OpenTweet
//
//  Created by Troy Brandt on 12/14/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

func configureTweet(_ cell: UICollectionViewListCell, with tweet: Tweet) -> UICollectionViewListCell {
    var content = cell.defaultContentConfiguration()
    var attributes = AttributeContainer()
    attributes.foregroundColor = .secondaryLabel
    let attributedTweet = tweet.attributedContent(withNameAttributes: attributes)
    content.attributedText = NSAttributedString(attributedTweet)
    content.secondaryText = tweet.author
    content.secondaryTextProperties.color = .secondaryLabel
    content.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .subheadline)
    
    if let avatarImage = tweet.avatarImage {
        content.image = avatarImage
        content.imageProperties.maximumSize = CGSize(width: 24, height: 24)
    } else {
        content.image = UIImage(systemName: "person.circle")
        content.imageProperties.preferredSymbolConfiguration = .init(font: content.textProperties.font, scale: .large)
    }
    
    cell.contentConfiguration = content
    cell.accessories = [.disclosureIndicator()]

    return cell
}
