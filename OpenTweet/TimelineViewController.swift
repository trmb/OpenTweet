//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

enum Colors: String {
    case background = "BackgroundColor"
}

private enum Section: CaseIterable {
    case timeline
}

private enum cellId: String {
    case tweetRow = "tweetRowIdentifier"
    case tweetDetailSegue = "showTweetDetail"
}

class TimelineViewController: UICollectionViewController {

    // MARK: Lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
		super.viewDidLoad()
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.blue]
        
        let backgroundColor = UIColor(named: Colors.background.rawValue)
        var config = UICollectionLayoutListConfiguration(appearance:.plain)

        config.backgroundColor = backgroundColor
        collectionView.collectionViewLayout =
          UICollectionViewCompositionalLayout.list(using: config)
        
        self.collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: cellId.tweetRow.rawValue)
        self.title = NSLocalizedString("Timeline", comment: "Timeline Title")
                
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.tweetCoordinator = appDelegate.tweetCoordinator
        
        self.applySnapshot()
	}
    
    // MARK: Data Source
    private var tweetCoordinator: TweetDataCoordinator = TweetDataCoordinator()
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Tweet> = {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Tweet> { cell, _, tweet in
            let _ = configureTweet(cell, with: tweet)
        }

        return UICollectionViewDiffableDataSource<Section, Tweet>(collectionView: collectionView) { (collectionView, indexPath, tweet) -> UICollectionViewListCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: tweet)
        }
    }()
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tweet>()
        snapshot.appendSections(Section.allCases)
        if let data = tweetCoordinator.timelineData {
            snapshot.appendItems(data.timeline)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension TimelineViewController { // UICollectionViewDelegate
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: cellId.tweetDetailSegue.rawValue, sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let indexPath = collectionView?.indexPathsForSelectedItems?.first,
            let destination = segue.destination as? TweetViewController {
            let tweet = tweetCoordinator.tweetForIndexPath(indexPath)
            destination.tweet = tweet
        }
    }
}
