//
//  CryptTests.swift
//  CryptTests
//
//  Created by Mac Owner on 15/10/2015.
//  Copyright © 2015 Crypt transfer. All rights reserved.
//

import XCTest
@testable import Crypt

class CryptTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testGlobalPrefsFetching() {
        NSUserDefaults.resetStandardUserDefaults()
        GlobalPrefs.sharedInstance.fetch(100)
        NSThread.sleepForTimeInterval(2)
        XCTAssertFalse(GlobalPrefs.sharedInstance.about.string.isEmpty)
        XCTAssertFalse(GlobalPrefs.sharedInstance.appTourMessages.isEmpty)
        XCTAssertFalse(GlobalPrefs.sharedInstance.faq.string.isEmpty)
        XCTAssertFalse(GlobalPrefs.sharedInstance.logoUrl.isEmpty)
        XCTAssertFalse(GlobalPrefs.sharedInstance.privacyPolicy.string.isEmpty)
        XCTAssertFalse(GlobalPrefs.sharedInstance.sharingUrl.isEmpty)
        XCTAssertFalse(GlobalPrefs.sharedInstance.supportedCurrencies.isEmpty)
        XCTAssertFalse(GlobalPrefs.sharedInstance.termsAndConditions.string.isEmpty)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
