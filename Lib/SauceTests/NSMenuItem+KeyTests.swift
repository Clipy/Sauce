//
//  NSMenuItem+KeyTests.swift
//
//  SauceTests
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015 Clipy Project.
//

import AppKit
import Testing
@testable import Sauce

struct NSMenuItem_KeyTests {
    @Test
    func keyConversionIgnoresCharacterCase() {
        let menuItem = NSMenuItem()
        menuItem.keyEquivalentModifierMask = .command

        menuItem.keyEquivalent = "b"
        #expect(menuItem.key == .b)

        menuItem.keyEquivalent = "B"
        #expect(menuItem.key == .b)

        menuItem.keyEquivalentModifierMask = .shift
        #expect(menuItem.key == .b)
    }
}
