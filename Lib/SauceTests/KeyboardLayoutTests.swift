// 
//  KeyboardLayoutTests.swift
//
//  SauceTests
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
// 
//  Copyright © 2015-2020 Clipy Project.
//

import XCTest
import Carbon
@testable import Sauce

// swiftlint:disable discarded_notification_center_observer
final class KeyboardLayoutTests: XCTestCase {

    // MARK: - Properties
    private let ABCKeyboardID = "com.apple.keylayout.ABC"
    private let japaneseKeyboardID = "com.apple.inputmethod.Kotoeri.Japanese"
    private let kotoeriKeyboardID = "com.apple.inputmethod.Kotoeri"
    private let dvorakKeyboardID = "com.apple.keylayout.Dvorak"
    private let modifierTransformer = ModifierTransformer()
    private let QWERTYVKeyCode = 9
    private let DvorakVKeyCode = 47 // swiftlint:disable:this identifier_name

    // MARK: - Tests
    func testKeyCodesForABCKeyboard() {
        let isInstalledABCKeyboard = isInstalledInputSource(id: ABCKeyboardID)
        XCTAssertTrue(installInputSource(id: ABCKeyboardID))
        XCTAssertTrue(selectInputSource(id: ABCKeyboardID))
        let notificationCenter = NotificationCenter()
        let keyboardLayout = KeyboardLayout(notificationCenter: notificationCenter)
        let vKeyCode = keyboardLayout.currentKeyCode(for: .v)
        XCTAssertEqual(vKeyCode, CGKeyCode(QWERTYVKeyCode))
        let vKey = keyboardLayout.currentKey(for: QWERTYVKeyCode)
        XCTAssertEqual(vKey, .v)
        let vCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: 0)
        XCTAssertEqual(vCharacter, "v")
        let vShiftCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: modifierTransformer.carbonFlags(from: .shift))
        XCTAssertEqual(vShiftCharacter, "V")
        let vOptionCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: modifierTransformer.carbonFlags(from: [.option]))
        XCTAssertEqual(vOptionCharacter, "√")
        let vShiftOptionCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: modifierTransformer.carbonFlags(from: [.shift, .option]))
        XCTAssertEqual(vShiftOptionCharacter, "◊")
        guard !isInstalledABCKeyboard else { return }
        uninstallInputSource(id: ABCKeyboardID)
    }

    func testKeyCodesForDvorakKeyboard() {
        let isInstalledDvorakKeyboard = isInstalledInputSource(id: dvorakKeyboardID)
        XCTAssertTrue(installInputSource(id: dvorakKeyboardID))
        XCTAssertTrue(selectInputSource(id: dvorakKeyboardID))
        let notificationCenter = NotificationCenter()
        let keyboardLayout = KeyboardLayout(notificationCenter: notificationCenter)
        let vKeyCode = keyboardLayout.currentKeyCode(for: .v)
        XCTAssertEqual(vKeyCode, CGKeyCode(DvorakVKeyCode))
        let vKey = keyboardLayout.currentKey(for: DvorakVKeyCode)
        XCTAssertEqual(vKey, .v)
        let vCharacter = keyboardLayout.currentCharacter(for: DvorakVKeyCode, carbonModifiers: 0)
        XCTAssertEqual(vCharacter, "v")
        let vShiftCharacter = keyboardLayout.currentCharacter(for: DvorakVKeyCode, carbonModifiers: modifierTransformer.carbonFlags(from: .shift))
        XCTAssertEqual(vShiftCharacter, "V")
        let vOptionCharacter = keyboardLayout.currentCharacter(for: DvorakVKeyCode, carbonModifiers: modifierTransformer.carbonFlags(from: [.option]))
        XCTAssertEqual(vOptionCharacter, "√")
        let vShiftOptionCharacter = keyboardLayout.currentCharacter(for: DvorakVKeyCode, carbonModifiers: modifierTransformer.carbonFlags(from: [.shift, .option]))
        XCTAssertEqual(vShiftOptionCharacter, "◊")
        guard !isInstalledDvorakKeyboard else { return }
        uninstallInputSource(id: dvorakKeyboardID)
    }

    func testKeyCodesJapanesesAndDvorakOnlyKeyboard() {
        let installedInputSources = fetchInputSource(includeAllInstalled: false)
        let isInstalledJapaneseKeyboard = isInstalledInputSource(id: japaneseKeyboardID)
        let isInstalledKotoeriKeyboard = isInstalledInputSource(id: kotoeriKeyboardID)
        let isInstalledDvorakKeyboard = isInstalledInputSource(id: dvorakKeyboardID)
        XCTAssertTrue(installInputSource(id: ABCKeyboardID))
        XCTAssertTrue(installInputSource(id: dvorakKeyboardID))
        XCTAssertTrue(installInputSource(id: kotoeriKeyboardID))
        XCTAssertTrue(installInputSource(id: japaneseKeyboardID))
        XCTAssertTrue(selectInputSource(id: ABCKeyboardID))
        XCTAssertTrue(selectInputSource(id: japaneseKeyboardID))
        XCTAssertTrue(uninstallInputSource(id: ABCKeyboardID))
        installedInputSources.filter { $0.id != japaneseKeyboardID && $0.id != dvorakKeyboardID && !$0.id.contains("Japanese") && !$0.id.contains("Kotoeri") }
            .forEach { uninstallInputSource(id: $0.id) }
        let notificationCenter = NotificationCenter()
        let keyboardLayout = KeyboardLayout(notificationCenter: notificationCenter)
        let vKeyCode = keyboardLayout.currentKeyCode(for: .v)
        XCTAssertEqual(vKeyCode, CGKeyCode(QWERTYVKeyCode))
        let vKey = keyboardLayout.currentKey(for: QWERTYVKeyCode)
        XCTAssertEqual(vKey, .v)
        let vCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: 0)
        XCTAssertEqual(vCharacter, "v")
        let vShiftCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: modifierTransformer.carbonFlags(from: .shift))
        XCTAssertEqual(vShiftCharacter, "V")
        let vOptionCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: modifierTransformer.carbonFlags(from: [.option]))
        XCTAssertEqual(vOptionCharacter, "√")
        let vShiftOptionCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: modifierTransformer.carbonFlags(from: [.shift, .option]))
        XCTAssertEqual(vShiftOptionCharacter, "◊")
        installedInputSources.forEach { installInputSource(id: $0.id) }
        if !isInstalledJapaneseKeyboard {
            uninstallInputSource(id: japaneseKeyboardID)
        }
        if !isInstalledDvorakKeyboard {
            uninstallInputSource(id: dvorakKeyboardID)
        }
        if !isInstalledKotoeriKeyboard {
            uninstallInputSource(id: kotoeriKeyboardID)
        }
    }

    func testInputSourceChangedNotification() {
        let isInstalledABCKeyboard = isInstalledInputSource(id: ABCKeyboardID)
        let isInstalledDvorakKeyboard = isInstalledInputSource(id: dvorakKeyboardID)
        XCTAssertTrue(installInputSource(id: ABCKeyboardID))
        XCTAssertTrue(uninstallInputSource(id: dvorakKeyboardID))
        XCTAssertTrue(selectInputSource(id: ABCKeyboardID))
        let notificationCenter = NotificationCenter()
        let keyboardLayout = KeyboardLayout(notificationCenter: notificationCenter)
        let selectedExpectation = XCTestExpectation(description: "Selected Keycobard Input Source Changed")
        selectedExpectation.expectedFulfillmentCount = 2
        selectedExpectation.assertForOverFulfill = true
        notificationCenter.addObserver(forName: .SauceSelectedKeyboardInputSourceChanged, object: nil, queue: nil) { _ in
            selectedExpectation.fulfill()
        }
        let enabledExpectation = XCTestExpectation(description: "Enabled Keycobard Input Source Changed")
        notificationCenter.addObserver(forName: .SauceEnabledKeyboardInputSourcesChanged, object: nil, queue: nil) { _ in
            enabledExpectation.fulfill()
        }
        XCTAssertTrue(installInputSource(id: dvorakKeyboardID))
        XCTAssertTrue(selectInputSource(id: dvorakKeyboardID))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.selectInputSource(id: self.ABCKeyboardID))
        }
        wait(for: [selectedExpectation, enabledExpectation], timeout: 2)
        if !isInstalledABCKeyboard {
            uninstallInputSource(id: ABCKeyboardID)
        }
        if !isInstalledDvorakKeyboard {
            uninstallInputSource(id: dvorakKeyboardID)
        }
    }

    func testKeyCodesChangedNotification() {
        let isInstalledABCKeyboard = isInstalledInputSource(id: ABCKeyboardID)
        let isInstalledDvorakKeyboard = isInstalledInputSource(id: dvorakKeyboardID)
        XCTAssertTrue(installInputSource(id: ABCKeyboardID))
        XCTAssertTrue(installInputSource(id: dvorakKeyboardID))
        XCTAssertTrue(selectInputSource(id: ABCKeyboardID))
        let notificationCenter = NotificationCenter()
        let keyboardLayout = KeyboardLayout(notificationCenter: notificationCenter)
        let expectation = XCTestExpectation(description: "Selected Keycobard Key Codes Changed")
        expectation.expectedFulfillmentCount = 2
        expectation.assertForOverFulfill = true
        notificationCenter.addObserver(forName: .SauceSelectedKeyboardKeyCodesChanged, object: nil, queue: nil) { _ in
            expectation.fulfill()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.selectInputSource(id: self.dvorakKeyboardID))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                XCTAssertTrue(self.selectInputSource(id: self.ABCKeyboardID))
            }
        }
        wait(for: [expectation], timeout: 2)
        if !isInstalledABCKeyboard {
            uninstallInputSource(id: ABCKeyboardID)
        }
        if !isInstalledDvorakKeyboard {
            uninstallInputSource(id: dvorakKeyboardID)
        }
    }

    // MARK: - Util
    private func fetchInputSource(includeAllInstalled: Bool) -> [InputSource] {
        guard let sources = TISCreateInputSourceList([:] as CFDictionary, includeAllInstalled).takeUnretainedValue() as? [TISInputSource] else { return [] }
        return sources.map { InputSource(source: $0) }
    }

    private func isInstalledInputSource(id: String) -> Bool {
        return fetchInputSource(includeAllInstalled: false).contains(where: { $0.id == id })
    }

    @discardableResult
    private func installInputSource(id: String) -> Bool {
        let allInputSources = fetchInputSource(includeAllInstalled: true)
        guard let targetInputSource = allInputSources.first(where: { $0.id == id }) else { return false }
        return TISEnableInputSource(targetInputSource.source) == noErr
    }

    @discardableResult
    private func uninstallInputSource(id: String) -> Bool {
        let installedInputSources = fetchInputSource(includeAllInstalled: false)
        guard let targetInputSource = installedInputSources.first(where: { $0.id == id }) else { return true }
        return TISDisableInputSource(targetInputSource.source) == noErr
    }

    @discardableResult
    private func selectInputSource(id: String) -> Bool {
        let installedInputSources = self.fetchInputSource(includeAllInstalled: false)
        guard let targetInputSource = installedInputSources.first(where: { $0.id == id }) else { return false }
        return TISSelectInputSource(targetInputSource.source) == noErr
    }

}
