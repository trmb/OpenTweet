//
//  TweetViewController.swift
//  OpenTweet
//
//  Created by Troy Brandt on 12/13/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import UIKit

enum cell: String {
    case header = "replyHeaderIdentifier"
    case tweetDetail = "tweetDetailIdentifier"
    case tweetReply = "replyTweetIdentifier"
}

class TweetViewController: UICollectionViewController {
    var tweetCoordinator: TweetDataCoordinator?
    var tweet: Tweet?
    var replyTo: Tweet?
    var replies: [Tweet]?
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        tweetCoordinator = appDelegate.tweetCoordinator
        let layout = UICollectionViewCompositionalLayout() { sectionIndex, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.headerMode = sectionIndex == 2 ? .supplementary : .none
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            return section
        }
        
        self.collectionView.collectionViewLayout = layout
        if let tweet = tweet {
            if let replyToId = tweet.replyId {
                if let replyTo = tweetCoordinator?.tweetFor(id: replyToId) {
                    self.replyTo = replyTo
                }
            }
            self.replies = tweetCoordinator?.repliesForTweet(id: tweet.id) ?? []
        }
        collectionView.allowsSelection = false
    }
}

extension TweetViewController { // UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cell.header.rawValue, for: indexPath)
            return headerView
        default:
            assert(false, "Invalid element type")
            return UICollectionReusableView()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return replyTo != nil ? 1 : 0
        case 1:
            return 1
        case 2:
            return replies?.count ?? 0
        default:
            return 0
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let replies = replies {
            return replies.count > 0 ? 3 : 2
        }
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            if let replyTo = replyTo {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell.tweetReply.rawValue, for: indexPath) as? UICollectionViewListCell
                if let cell = cell {
                    let configuredCell = configureTweet(cell, with: replyTo)
                    configuredCell.accessories = []
                }
                return cell!
            }
            return UICollectionViewCell()
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell.tweetDetail.rawValue, for: indexPath) as? TweetDetailViewCell
            if let cell = cell, let tweet = tweet {
                cell.updateWithTweet(tweet)
            }
            return cell!
        case 2:
            if let reply = replies?[indexPath.row] {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cell.tweetReply.rawValue, for: indexPath) as? UICollectionViewListCell
                if let cell = cell {
                    let configuredCell = configureTweet(cell, with: reply)
                    configuredCell.accessories = []
                }
                return cell!
            }
            return UICollectionViewCell()
        default:
            return UICollectionViewCell()
        }

    }
}
