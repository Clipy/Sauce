// 
//  NSMenuItem+KeyTests.swift
//
//  SauceTests
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
// 
//  Copyright © 2015-2021 Clipy Project.
//

import XCTest
import AppKit
@testable import Sauce

class NSMenuItem_KeyTests: XCTestCase {
    func testKeyConversionIgnoresCharacterCase() {
        let menuItem = NSMenuItem()
        menuItem.keyEquivalentModifierMask = .command

        menuItem.keyEquivalent = "b"
        XCTAssertEqual(menuItem.key, .b)

        menuItem.keyEquivalent = "B"
        XCTAssertEqual(menuItem.key, .b)

        menuItem.keyEquivalentModifierMask = .shift
        XCTAssertEqual(menuItem.key, .b)
    }
}
