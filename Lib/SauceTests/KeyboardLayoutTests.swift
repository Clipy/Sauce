import Carbon
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

    private let QWERTYVKeyCode = 9
    private let dvorakVKeyCode = 47

    // MARK: - Tests
    @Test(
        .serialized,
        .inputSource(enableIDs: [ABCKeyboardID], selectIDs: [ABCKeyboardID]),
        arguments: [0, cmdKey]
    )
    func keyCodesForABCKeyboard(carbonModifier: Int) {
        let notificationCenter = NotificationCenter()
        let keyboardLayout = KeyboardLayout(notificationCenter: notificationCenter)

        let vKeyCode = keyboardLayout.currentKeyCode(for: .v, carbonModifiers: carbonModifier)
        #expect(vKeyCode == CGKeyCode(QWERTYVKeyCode))

        let vKey = keyboardLayout.currentKey(for: QWERTYVKeyCode, carbonModifiers: carbonModifier)
        #expect(vKey == .v)

        let vCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: carbonModifier)
        #expect(vCharacter == "v")

        let vShiftCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: shiftKey | carbonModifier)
        #expect(vShiftCharacter == "V")

        let vOptionCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: optionKey | carbonModifier)
        #expect(vOptionCharacter == "√")

        let vShiftOptionCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: shiftKey | optionKey | carbonModifier)
        #expect(vShiftOptionCharacter == "◊")
    }

    @Test(
        .inputSource(enableIDs: [dvorakKeyboardID], selectIDs: [dvorakKeyboardID])
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
        .inputSource(enableIDs: [dvorakQWERTYKeyboardID], selectIDs: [dvorakQWERTYKeyboardID])
    )
    func keyCodesForDvorakQWERTYKeyboard() {
        let notificationCenter = NotificationCenter()
        let keyboardLayout = KeyboardLayout(notificationCenter: notificationCenter)

        let vKeyCode = keyboardLayout.currentKeyCode(for: .v, carbonModifiers: 0)
        let vCommandKeyCode = keyboardLayout.currentKeyCode(for: .v, carbonModifiers: cmdKey)
        #expect(vKeyCode == CGKeyCode(dvorakVKeyCode))
        #expect(vCommandKeyCode == CGKeyCode(QWERTYVKeyCode))

        let vKey = keyboardLayout.currentKey(for: dvorakVKeyCode, carbonModifiers: 0)
        let vCommandKey = keyboardLayout.currentKey(for: QWERTYVKeyCode, carbonModifiers: cmdKey)
        #expect(vKey == .v)
        #expect(vCommandKey == .v)

        let vCharacter = keyboardLayout.currentCharacter(for: dvorakVKeyCode, carbonModifiers: 0)
        let vCommandCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: cmdKey)
        #expect(vCharacter == "v")
        #expect(vCommandCharacter == "v")

        let vShiftCharacter = keyboardLayout.currentCharacter(for: dvorakVKeyCode, carbonModifiers: shiftKey)
        let vCommandShiftCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: cmdKey | shiftKey)
        #expect(vShiftCharacter == "V")
        #expect(vCommandShiftCharacter == "V")

        let vOptionCharacter = keyboardLayout.currentCharacter(for: dvorakVKeyCode, carbonModifiers: optionKey)
        let vCommandOptionCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: cmdKey | optionKey)
        #expect(vOptionCharacter == "√")
        #expect(vCommandOptionCharacter == "√")

        let vShiftOptionCharacter = keyboardLayout.currentCharacter(for: dvorakVKeyCode, carbonModifiers: shiftKey | optionKey)
        let vCommandShiftOptionCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: cmdKey | shiftKey | optionKey)
        #expect(vShiftOptionCharacter == "◊")
        #expect(vCommandShiftOptionCharacter == "◊")
    }

    @Test(
        .inputSource(
            enableIDs: [ABCKeyboardID, dvorakKeyboardID, kotoeriKeyboardID, japaneseKeyboardID],
            selectIDs: [ABCKeyboardID, japaneseKeyboardID],
            disableIDs: [ABCKeyboardID]
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
        #expect(vKeyCode == CGKeyCode(QWERTYVKeyCode))

        let vKey = keyboardLayout.currentKey(for: QWERTYVKeyCode, carbonModifiers: 0)
        #expect(vKey == .v)

        let vCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: 0)
        #expect(vCharacter == "v")

        let vShiftCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: shiftKey)
        #expect(vShiftCharacter == "V")

        let vOptionCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: optionKey)
        #expect(vOptionCharacter == "√")

        let vShiftOptionCharacter = keyboardLayout.currentCharacter(for: QWERTYVKeyCode, carbonModifiers: shiftKey | optionKey)
        #expect(vShiftOptionCharacter == "◊")
    }

    @available(macOS 13, *)
    @Test(
        .inputSource(
            enableIDs: [ABCKeyboardID, dvorakKeyboardID],
            selectIDs: [ABCKeyboardID],
            disableIDs: [dvorakKeyboardID]
        ),
        .timeLimit(.minutes(1))
    )
    func inputSourceChangedNotification() async throws {
        let notificationCenter = NotificationCenter()
        let keyboardLayout = KeyboardLayout(notificationCenter: notificationCenter)

        let selectedSourceChanged = notificationCenter.notifications(named: .SauceSelectedKeyboardInputSourceChanged)
        let enabledSourceChanged = notificationCenter.notifications(named: .SauceEnabledKeyboardInputSourcesChanged)
        let selectedSourceTask = Task<Void?, Never> { @MainActor in
            for await _ in selectedSourceChanged {
                return ()
            }
            return nil
        }
        let enabledSourceTask = Task<Void?, Never> { @MainActor in
            for await _ in enabledSourceChanged {
                return ()
            }
            return nil
        }

        let dvorakInputSource = try #require(InputSource.allInputSources.first { $0.id == Self.dvorakKeyboardID })
        #expect(dvorakInputSource.enable() == true)
        #expect(dvorakInputSource.select() == true)

        #expect(await selectedSourceTask.value != nil)
        #expect(await enabledSourceTask.value != nil)

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
        let keyCodesTask = Task<Void?, Never> { @MainActor in
            for await _ in keyCodesChanged {
                return ()
            }
            return nil
        }

        let dvorakInputSource = try #require(InputSource.allInputSources.first { $0.id == Self.dvorakKeyboardID })
        #expect(dvorakInputSource.select() == true)

        #expect(await keyCodesTask.value != nil)

        withExtendedLifetime(keyboardLayout) {}
    }
}
