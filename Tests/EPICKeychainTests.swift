//
//  EPICKeychainTests.swift
//  EPICKeychain
//
//  Created by Danny Bravo on 25/09/2015.
//  Copyright © 2015 EPIC. All rights reserved.
//

import XCTest

//MARK: - constants
private let PASSWORD = "A PASSWORD STRING"
private let OTHER_PASSWORD = "ANOTHER PASSWORD STRING"
private let KEY = "A KEY"

class EPICKeychainTests: XCTestCase {
    
    //MARK: - tests
    func testKeychainManager() {
        XCTAssertNil(EPICKeychainManager.passwordForKey(KEY))
        
        XCTAssertTrue(EPICKeychainManager.storePassword(PASSWORD, forKey: KEY, hash: false, iCloudAccessGroup: nil))
        XCTAssertTrue(EPICKeychainManager.checkPassword(PASSWORD, forKey: KEY, hash: false))
        XCTAssertFalse(EPICKeychainManager.checkPassword(PASSWORD, forKey: KEY, hash: true))
        XCTAssertFalse(EPICKeychainManager.checkPassword(OTHER_PASSWORD, forKey: KEY, hash: false))
        XCTAssertFalse(EPICKeychainManager.checkPassword(OTHER_PASSWORD, forKey: KEY, hash: true))
        XCTAssertEqual(EPICKeychainManager.passwordForKey(KEY), PASSWORD)
        
        XCTAssertTrue(EPICKeychainManager.storePassword(OTHER_PASSWORD, forKey: KEY, hash: true, iCloudAccessGroup: nil))
        XCTAssertFalse(EPICKeychainManager.checkPassword(PASSWORD, forKey: KEY, hash: false))
        XCTAssertFalse(EPICKeychainManager.checkPassword(PASSWORD, forKey: KEY, hash: true))
        XCTAssertFalse(EPICKeychainManager.checkPassword(OTHER_PASSWORD, forKey: KEY, hash: false))
        XCTAssertTrue(EPICKeychainManager.checkPassword(OTHER_PASSWORD, forKey: KEY, hash: true))
        XCTAssertNotEqual(EPICKeychainManager.passwordForKey(KEY), OTHER_PASSWORD)
        XCTAssertEqual(EPICKeychainManager.passwordForKey(KEY), OTHER_PASSWORD.hashUsingAlgorithm(.SHA512))

        XCTAssertTrue(EPICKeychainManager.storePassword(PASSWORD, forKey: KEY, hash: true, iCloudAccessGroup: nil))
        
        XCTAssertTrue(EPICKeychainManager.removePasswordForKey(KEY))
        XCTAssertTrue(EPICKeychainManager.removePasswordForKey(KEY))
        XCTAssertNil(EPICKeychainManager.passwordForKey(KEY))
        XCTAssertFalse(EPICKeychainManager.checkPassword(PASSWORD, forKey: KEY, hash: false))
        XCTAssertFalse(EPICKeychainManager.checkPassword(PASSWORD, forKey: KEY, hash: true))
        XCTAssertFalse(EPICKeychainManager.checkPassword(OTHER_PASSWORD, forKey: KEY, hash: false))
        XCTAssertFalse(EPICKeychainManager.checkPassword(OTHER_PASSWORD, forKey: KEY, hash: true))
    }

}
