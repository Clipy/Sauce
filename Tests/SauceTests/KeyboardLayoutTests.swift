//
//  KeyboardLayoutTests.swift
//
//  SauceTests
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015 Clipy Project.
//

import Carbon
import Foundation
import Testing
@testable import Sauce

@Suite(.serialized)
@MainActor
final class KeyboardLayoutTests {
    // MARK: - Properties
    private static let ABCKeyboardID = "com.apple.keylayout.ABC"
    private static let dvorakKeyboardID = "com.apple.keylayout.Dvorak"
    private static let dvorakQWERTYKeyboardID = "com.apple.keylayout.DVORAK-QWERTYCMD"
    private static let japaneseKeyboardID = "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese"
    private static let kotoeriKeyboardID = "com.apple.inputmethod.Kotoeri.RomajiTyping"
    private let qwertyVKeyCode = 9
    private let dvorakVKeyCode = 47

    // MARK: - Tests
    @Test(
        .inputSource(enableIDs: [ABCKeyboardID], selectIDs: [ABCKeyboardID]),
        arguments: [0, cmdKey]
    )
    func keyCodesForABCKeyboard(carbonModifier: Int) {
        let notificationCenter = NotificationCenter()
        let keyboardLayout = KeyboardLayout(notificationCenter: notificationCenter)

        let vKeyCode = keyboardLayout.currentKeyCode(for: .v, carbonModifiers: carbonModifier)
        #expect(vKeyCode == CGKeyCode(qwertyVKeyCode))

        let vKey = keyboardLayout.currentKey(for: qwertyVKeyCode, carbonModifiers: carbonModifier)
        #expect(vKey == .v)

        let vCharacter = keyboardLayout.currentCharacter(for: qwertyVKeyCode, carbonModifiers: carbonModifier)
        #expect(vCharacter == "v")

        let vShiftCharacter = keyboardLayout.currentCharacter(for: qwertyVKeyCode, carbonModifiers: shiftKey | carbonModifier)
        #expect(vShiftCharacter == "V")

        let vOptionCharacter = keyboardLayout.currentCharacter(for: qwertyVKeyCode, carbonModifiers: optionKey | carbonModifier)
        #expect(vOptionCharacter == "√")

        let vShiftOptionCharacter = keyboardLayout.currentCharacter(for: qwertyVKeyCode, carbonModifiers: shiftKey | optionKey | carbonModifier)
        #expect(vShiftOptionCharacter == "◊")
    }

    @Test(
        .inputSource(enableIDs: [ABCKeyboardID], selectIDs: [ABCKeyboardID]),
        .bug("https://github.com/Clipy/Sauce/issues/89")
    )
    func keypadEnterUsesCarbonVirtualKeyCode() throws {
        let sauce = Sauce()

        let keyCode = sauce.keyCode(for: .keypadEnter)
        #expect(keyCode == CGKeyCode(kVK_ANSI_KeypadEnter))

        let character = try #require(sauce.character(for: Int(keyCode)))
        #expect(character == "⌅")
    }

    @Test(
        .inputSource(enableIDs: [ABCKeyboardID, dvorakKeyboardID], selectIDs: [dvorakKeyboardID])
    )
    func keyCodesForDvorakKeyboard() {
        let notificationCenter = NotificationCenter()
        let keyboardLayout = KeyboardLayout(notificationCenter: notificationCenter)

        let vKeyCode = keyboardLayout.currentKeyCode(for: .v, carbonModifiers: 0)
        #expect(vKeyCode == CGKeyCode(dvorakVKeyCode))

        let vKey = keyboardLayout.currentKey(for: dvorakVKeyCode, carbonModifiers: 0)
        #expect(vKey == .v)

        let vCharacter = keyboardLayout.currentCharacter(for: dvorakVKeyCode, carbonModifiers: 0)
        #expect(vCharacter == "v")

        let vShiftCharacter = keyboardLayout.currentCharacter(for: dvorakVKeyCode, carbonModifiers: shiftKey)
        #expect(vShiftCharacter == "V")

        let vOptionCharacter = keyboardLayout.currentCharacter(for: dvorakVKeyCode, carbonModifiers: optionKey)
        #expect(vOptionCharacter == "√")

        let vShiftOptionCharacter = keyboardLayout.currentCharacter(for: dvorakVKeyCode, carbonModifiers: shiftKey | optionKey)
        #expect(vShiftOptionCharacter == "◊")
    }

    @Test(
        .inputSource(enableIDs: [ABCKeyboardID, dvorakQWERTYKeyboardID], selectIDs: [dvorakQWERTYKeyboardID])
    )
    func keyCodesForDvorakQWERTYKeyboard() {
        let notificationCenter = NotificationCenter()
        let keyboardLayout = KeyboardLayout(notificationCenter: notificationCenter)

        let vKeyCode = keyboardLayout.currentKeyCode(for: .v, carbonModifiers: 0)
        let vCommandKeyCode = keyboardLayout.currentKeyCode(for: .v, carbonModifiers: cmdKey)
        #expect(vKeyCode == CGKeyCode(dvorakVKeyCode))
        #expect(vCommandKeyCode == CGKeyCode(qwertyVKeyCode))

        let vKey = keyboardLayout.currentKey(for: dvorakVKeyCode, carbonModifiers: 0)
        let vCommandKey = keyboardLayout.currentKey(for: qwertyVKeyCode, carbonModifiers: cmdKey)
        #expect(vKey == .v)
        #expect(vCommandKey == .v)

        let vCharacter = keyboardLayout.currentCharacter(for: dvorakVKeyCode, carbonModifiers: 0)
        let vCommandCharacter = keyboardLayout.currentCharacter(for: qwertyVKeyCode, carbonModifiers: cmdKey)
        #expect(vCharacter == "v")
        #expect(vCommandCharacter == "v")

        let vShiftCharacter = keyboardLayout.currentCharacter(for: dvorakVKeyCode, carbonModifiers: shiftKey)
        let vCommandShiftCharacter = keyboardLayout.currentCharacter(for: qwertyVKeyCode, carbonModifiers: cmdKey | shiftKey)
        #expect(vShiftCharacter == "V")
        #expect(vCommandShiftCharacter == "V")

        let vOptionCharacter = keyboardLayout.currentCharacter(for: dvorakVKeyCode, carbonModifiers: optionKey)
        let vCommandOptionCharacter = keyboardLayout.currentCharacter(for: qwertyVKeyCode, carbonModifiers: cmdKey | optionKey)
        #expect(vOptionCharacter == "√")
        #expect(vCommandOptionCharacter == "√")

        let vShiftOptionCharacter = keyboardLayout.currentCharacter(for: dvorakVKeyCode, carbonModifiers: shiftKey | optionKey)
        let vCommandShiftOptionCharacter = keyboardLayout.currentCharacter(for: qwertyVKeyCode, carbonModifiers: cmdKey | shiftKey | optionKey)
        #expect(vShiftOptionCharacter == "◊")
        #expect(vCommandShiftOptionCharacter == "◊")
    }

    @Test(
        .inputSource(
            enableIDs: [ABCKeyboardID, dvorakKeyboardID, kotoeriKeyboardID, japaneseKeyboardID],
            selectIDs: [ABCKeyboardID, japaneseKeyboardID]
        ),
        .bug("https://github.com/Clipy/Sauce/pull/15")
    )
    func keyCodesJapanesesAndDvorakOnlyKeyboard() {
        InputSource.enabledInputSources
            .filter {
                $0.id != Self.japaneseKeyboardID &&
                $0.id != Self.dvorakKeyboardID &&
                !$0.id.contains("Japanese") &&
                !$0.id.contains("Kotoeri")
            }
            .forEach { $0.disable() }

        let notificationCenter = NotificationCenter()
        let keyboardLayout = KeyboardLayout(notificationCenter: notificationCenter)

        let vKeyCode = keyboardLayout.currentKeyCode(for: .v, carbonModifiers: 0)
        #expect(vKeyCode == CGKeyCode(qwertyVKeyCode))

        let vKey = keyboardLayout.currentKey(for: qwertyVKeyCode, carbonModifiers: 0)
        #expect(vKey == .v)

        let vCharacter = keyboardLayout.currentCharacter(for: qwertyVKeyCode, carbonModifiers: 0)
        #expect(vCharacter == "v")

        let vShiftCharacter = keyboardLayout.currentCharacter(for: qwertyVKeyCode, carbonModifiers: shiftKey)
        #expect(vShiftCharacter == "V")

        let vOptionCharacter = keyboardLayout.currentCharacter(for: qwertyVKeyCode, carbonModifiers: optionKey)
        #expect(vOptionCharacter == "√")

        let vShiftOptionCharacter = keyboardLayout.currentCharacter(for: qwertyVKeyCode, carbonModifiers: shiftKey | optionKey)
        #expect(vShiftOptionCharacter == "◊")
    }

    @available(macOS 13, *)
    @Test(
        .inputSource(enableIDs: [ABCKeyboardID], selectIDs: [ABCKeyboardID]),
        .timeLimit(.minutes(1))
    )
    func inputSourceChangedNotification() async throws {
        let notificationCenter = NotificationCenter()
        let keyboardLayout = KeyboardLayout(notificationCenter: notificationCenter)

        let selectedSourceChanged = notificationCenter.notifications(named: .SauceSelectedKeyboardInputSourceChanged)
        let enabledSourceChanged = notificationCenter.notifications(named: .SauceEnabledKeyboardInputSourcesChanged)
        let selectedSourceTask = Task<Int, Never> { @MainActor in
            var count = 0
            for await _ in selectedSourceChanged {
                count += 1
                if count == 2 {
                    break
                }
            }
            return count
        }
        let enabledSourceTask = Task<Int, Never> { @MainActor in
            var count = 0
            for await _ in enabledSourceChanged {
                count += 1
                if count == 1 {
                    break
                }
            }
            return count
        }

        let abcInputSource = try #require(InputSource.allInputSources.first { $0.id == Self.ABCKeyboardID })
        let dvorakInputSource = try #require(InputSource.allInputSources.first { $0.id == Self.dvorakKeyboardID })

        #expect(dvorakInputSource.enable())
        #expect(dvorakInputSource.select())
        try await Task.sleep(for: .seconds(1))
        #expect(abcInputSource.select())

        #expect((await selectedSourceTask.value) == 2)
        #expect((await enabledSourceTask.value) == 1)

        withExtendedLifetime(keyboardLayout) {}
    }

    @available(macOS 13, *)
    @Test(
        .inputSource(
            enableIDs: [ABCKeyboardID, dvorakKeyboardID],
            selectIDs: [ABCKeyboardID]
        ),
        .timeLimit(.minutes(1))
    )
    func keyCodesChangedNotification() async throws {
        let notificationCenter = NotificationCenter()
        let keyboardLayout = KeyboardLayout(notificationCenter: notificationCenter)

        let keyCodesChanged = notificationCenter.notifications(named: .SauceSelectedKeyboardKeyCodesChanged)
        let keyCodesTask = Task<Int, Never> { @MainActor in
            var count = 0
            for await _ in keyCodesChanged {
                count += 1
                if count == 2 {
                    break
                }
            }
            return count
        }

        let abcInputSource = try #require(InputSource.allInputSources.first { $0.id == Self.ABCKeyboardID })
        let dvorakInputSource = try #require(InputSource.allInputSources.first { $0.id == Self.dvorakKeyboardID })

        #expect(dvorakInputSource.select())
        try await Task.sleep(for: .seconds(1))
        #expect(abcInputSource.select())

        #expect((await keyCodesTask.value) == 2)

        withExtendedLifetime(keyboardLayout) {}
    }
}
