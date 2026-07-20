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

struct NSMenuItemKeyTests {
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

    @Test(.bug("https://github.com/Clipy/Sauce/pull/88"))
    func enterKeyEquivalentMapsToKeypadEnter() throws {
        let enterCharacter = try #require(UnicodeScalar(NSEnterCharacter))
        let menuItem = NSMenuItem()
        menuItem.keyEquivalent = String(enterCharacter)

        let key = try #require(menuItem.key)
        #expect(key == .keypadEnter)
    }
}
