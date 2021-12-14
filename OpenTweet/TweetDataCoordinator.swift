//
//  tweetDataCoordinator.swift
//  OpenTweet
//
//  Created by Troy Brandt on 12/13/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation

class TweetDataCoordinator {
    var timelineData: TweetData?
    init() {
        fetchData()
    }
    
    private func fetchData() {
        if let file = Bundle.main.url(forResource: "timeline", withExtension: "json") {
            do {
                let data = try Data(contentsOf: file)
                let json = try JSONDecoder().decode(TweetData.self, from: data)
                self.timelineData = json
                
            } catch {
                print("There was a problem loading data \(error)")
            }
        }
    }
    
    // API
    public func timeLineLength() -> Int {
        guard let data = timelineData else {
            return 0
        }
        return data.timeline.count
    }
    
    public func tweetAtIndex(_ index: Int) -> Tweet? {
        guard let data = timelineData else {
            return nil
        }
        return data.timeline[index]
    }
    
    /// Returns a Tweet based of the row component of an index path. 
    public func tweetForIndexPath(_ indexPath: IndexPath) -> Tweet? {
        return tweetAtIndex(indexPath.row)
    }
    
    /// Returns a list of tweet replies based on the current id
    public func repliesForTweet(id tweetId: Int) -> [Tweet] {
        guard let data = timelineData else {
            return []
        }
        return data.timeline.filter { $0.replyId == tweetId }
    }
    
    /// Return a tweet based off of tweet id
    public func tweetFor(id tweetId: Int) -> Tweet? {
        guard let data = timelineData else {
            return nil
        }
        return data.timeline.filter { $0.id == tweetId }.first
    }
}
