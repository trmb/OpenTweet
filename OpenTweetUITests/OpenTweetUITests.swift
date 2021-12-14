//
//  OpenTweetUITests.swift
//  OpenTweetUITests
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import XCTest

class OpenTweetUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitialStateCollectionView() {
        let collection = XCUIApplication().collectionViews
        XCTAssertTrue(collection.cells.count > 2)
    }
    
    func testTweetShowsRepliesIfPResent() {
        let app = XCUIApplication()
        app.collectionViews.cells.element(boundBy: 1).tap()
        XCTAssertTrue(app.collectionViews.staticTexts["Replies"].exists)
    }
    
    func testTweetDoesNotShowsRepliesWhenNotPresent() {
        let app = XCUIApplication()
        app.collectionViews.cells.element(boundBy: 0).tap()
        XCTAssertFalse(app.collectionViews.cells["Replies"].exists)
    }
    
    func testGoBackFromTweet() {
        let app = XCUIApplication()
        app.collectionViews.cells.element(boundBy: 1).tap()
        app.buttons["Timeline"].tap()
    }
}
