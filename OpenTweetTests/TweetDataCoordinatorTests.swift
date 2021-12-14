//
//  TweetDataCoordinatorTests.swift
//  OpenTweetTests
//
//  Created by Troy Brandt on 12/14/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import XCTest
@testable import OpenTweet

class TweetDataCoordinatorTests: XCTestCase {
    var tweetData: TweetDataCoordinator?

    override func setUpWithError() throws {
        super.setUp()
        tweetData = TweetDataCoordinator()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    func testLoadData() throws {
        XCTAssertNotNil(tweetData?.timelineData)
    }

    func testTweetTimelineLength() throws {
        XCTAssertTrue(tweetData?.timeLineLength() == 7)
    }
    
    func testTweetForIndexPath() throws {
        let idx = IndexPath(row: 1, section: 0)
        let tweet = tweetData?.tweetForIndexPath(idx)
        XCTAssertTrue(tweet?.id == 42)
    }
    
    func testTweetForId() throws {
        if let tweet = tweetData?.tweetFor(id: 42) {
            XCTAssertTrue(tweet.content.contains("Long day at opentable!"))
        }
        
        let notFoundTweet = tweetData?.tweetFor(id: 999)
        
        XCTAssertNil(notFoundTweet)
    }
    
    func testRepliesForTweet() throws {
        if let replies = tweetData?.repliesForTweet(id: 42) {
            XCTAssertTrue(replies.count == 3)
        }
        
        // id not found
        let notFoundTweetReplies = tweetData?.repliesForTweet(id: 999)
        XCTAssertTrue(notFoundTweetReplies?.count == 0)
        
        // id found, no replies
        let noReplies = tweetData?.repliesForTweet(id: 1)
        XCTAssertTrue(noReplies?.count == 0)
    }
    
    func testAvatarURL() throws {
        if let tweet = tweetData?.tweetAtIndex(0) {
            let matches = tweet.avatarUrl?.absoluteString.contains("https://i.imgflip.com/ohrrn.jpg") ?? false
            XCTAssertTrue(matches)
        }
    }
    
    func testTweetDate() throws {
        if let tweet = tweetData?.tweetAtIndex(0) {
            let tweetDate = tweet.date
            let realDateStr = "2020-09-29T14:41:00-08:00"
            let dateFormatter = ISO8601DateFormatter()
            let d = dateFormatter.date(from:realDateStr)

            XCTAssertTrue(tweetDate == d)
        }
    }
}
