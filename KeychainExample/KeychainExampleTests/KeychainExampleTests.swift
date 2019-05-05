//
//  KeychainExampleTests.swift
//  KeychainExampleTests
//
//  Created by Ramon Geronimo on 4/29/19.
//  Copyright © 2019 Ramon Geronimo. All rights reserved.
//

import XCTest
@testable import KeychainExample
//Don't forget to import the library KeychainSwift
import KeychainSwift

class KeychainExampleTests: XCTestCase {
    
    // For all of the tests we will need an instance of KeychainSwift
    var keychain = KeychainSwift()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testKeychainGet() {
        // Test if retrieving a value with Keychain works.
        keychain.set(true, forKey: "secret")
        XCTAssertEqual(true, (keychain.get("secret") != nil))
    }
    
    func testKeychainDelete() {
        // Test if deleting a value with Keychain works.
        keychain.delete("secret")
        XCTAssertNil(keychain.get("secret"))
    }
    
    func testKeychainUpdate() {
        // Test if updating a value with Keychain works, you will need an initial value and compare the new value with the old one.
        keychain.set("UpdatedTest", forKey: "test")
        if let newValue = keychain.get("test") {
            XCTAssertEqual("UpdatedTest", newValue)
        }
    }
}
