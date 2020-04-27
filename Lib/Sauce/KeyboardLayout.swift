//
//  KeyboardLayout.swift
//
//  Sauce
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015-2019 Clipy Project.
//

import Foundation
import Carbon

final class KeyboardLayout {

    // MARK: - Properties
    private(set) var currentInputSource: InputSource
    private(set) var currentASCIICapableInputSouce: InputSource
    private(set) var ASCIICapableInputSources = [InputSource]()
    private(set) var mappedKeyCodes = [InputSource: [Key: CGKeyCode]]()

    var currentKeyCodes: [Key: CGKeyCode]? {
        return mappedKeyCodes[currentInputSource]
    }

    private let distributedNotificationCenter: DistributedNotificationCenter
    private let notificationCenter: NotificationCenter

    // MARK: - Initialize
    init(distributedNotificationCenter: DistributedNotificationCenter = .default(), notificationCenter: NotificationCenter = .default) {
        self.distributedNotificationCenter = distributedNotificationCenter
        self.notificationCenter = notificationCenter
        self.currentInputSource = InputSource(source: TISCopyCurrentKeyboardInputSource().takeUnretainedValue())
        /**
         *  Known issue1:
         *  When using TISCopyCurrentASCIICapableKeyboardLayoutInputSource, you can obtain InputSource which always has keyboard layout.
         *  However, if Dvorak layout and Japanese(en) layout are set, Dvorak layout will always be returned,
         *  and incorrect values will be returned when using Japanese(en) keyboard as input source.
         *
         *  Known issue2:
         *  When setting only Dvorak layout and Japanese layout,
         *  Dvorak layout is always set to currentASCIICapableInputSouce,
         *  so currentASCIICapableKeyCode and currentASCIICapableCharacter always returns to Dvorak layout.
         **/
        self.currentASCIICapableInputSouce = InputSource(source: TISCopyCurrentASCIICapableKeyboardInputSource().takeUnretainedValue())
        fetchASCIICapableInputSources()
        observeNotifications()
    }

    deinit {
        distributedNotificationCenter.removeObserver(self)
    }

}

// MARK: - KeyCodes
extension KeyboardLayout {
    func currentKeyCode(by key: Key) -> CGKeyCode? {
        return currentKeyCodes?[key]
    }

    func keyCodes(with source: InputSource) -> [Key: CGKeyCode]? {
        return mappedKeyCodes[source]
    }

    func keyCode(with source: InputSource, key: Key) -> CGKeyCode? {
        return mappedKeyCodes[source]?[key]
    }

    func currentASCIICapableKeyCode(by key: Key) -> CGKeyCode? {
        return keyCode(with: currentASCIICapableInputSouce, key: key)
    }
}

// MARK: - Characters
extension KeyboardLayout {
    func currentCharacter(by keyCode: Int, carbonModifiers: Int) -> String? {
        return character(with: currentInputSource.source, keyCode: keyCode, carbonModifiers: carbonModifiers)
    }

    func character(with source: InputSource, keyCode: Int, carbonModifiers: Int) -> String? {
        return character(with: source.source, keyCode: keyCode, carbonModifiers: carbonModifiers)
    }

    func currentASCIICapableCharacter(by keyCode: Int, carbonModifiers: Int) -> String? {
        return character(with: currentASCIICapableInputSouce.source, keyCode: keyCode, carbonModifiers: carbonModifiers)
    }
}

// MARK: - Notifications
extension KeyboardLayout {
    private func observeNotifications() {
        distributedNotificationCenter.addObserver(self,
                                                  selector: #selector(selectedKeyboardInputSourceChanged),
                                                  name: NSNotification.Name(kTISNotifySelectedKeyboardInputSourceChanged as String),
                                                  object: nil,
                                                  suspensionBehavior: .deliverImmediately)
        distributedNotificationCenter.addObserver(self,
                                                  selector: #selector(enabledKeyboardInputSourcesChanged),
                                                  name: Notification.Name(kTISNotifyEnabledKeyboardInputSourcesChanged as String),
                                                  object: nil,
                                                  suspensionBehavior: .deliverImmediately)
    }

    @objc func selectedKeyboardInputSourceChanged() {
        let source = InputSource(source: TISCopyCurrentKeyboardInputSource().takeUnretainedValue())
        guard source != currentInputSource else { return }
        self.currentInputSource = source
        self.currentASCIICapableInputSouce = InputSource(source: TISCopyCurrentASCIICapableKeyboardInputSource().takeUnretainedValue())
        notificationCenter.post(name: .SauceSelectedKeyboardInputSourceChanged, object: nil)
    }

    @objc func enabledKeyboardInputSourcesChanged() {
        fetchASCIICapableInputSources()
        notificationCenter.post(name: .SauceEnabledKeyboardInputSoucesChanged, object: nil)
    }
}

// MAKR: - Layouts
private extension KeyboardLayout {
    func fetchASCIICapableInputSources() {
        ASCIICapableInputSources = []
        mappedKeyCodes = [:]
        guard let sources = TISCreateASCIICapableInputSourceList().takeUnretainedValue() as? [TISInputSource] else { return }
        ASCIICapableInputSources = sources.map { InputSource(source: $0) }
        ASCIICapableInputSources.forEach { mappingKeyCodes(with: $0) }
    }

    func mappingKeyCodes(with source: InputSource) {
        var keyCodes = [Key: CGKeyCode]()
        /**
         *  Scan key codes
         *
         *  Known issue:
         *  For lauout like Japanese(en), kTISPropertyUnicodeKeyLayoutData returns NULL even if it is ASCIICapableInputSource
         *  Therefore, mapping is not performed when only Japanese is used as a keyboard
         **/
        guard let layoutData = TISGetInputSourceProperty(source.source, kTISPropertyUnicodeKeyLayoutData) else { return }
        let data = Unmanaged<CFData>.fromOpaque(layoutData).takeUnretainedValue() as Data

        for i in 0..<128 {
            guard let character = character(with: data, keyCode: i, carbonModifiers: 0) else { continue }
            guard let key = Key(character: character) else { continue }
            keyCodes[key] = CGKeyCode(i)
        }
        mappedKeyCodes[source] = keyCodes
    }

    func character(with source: TISInputSource, keyCode: Int, carbonModifiers: Int) -> String? {
        guard let layoutData = TISGetInputSourceProperty(source, kTISPropertyUnicodeKeyLayoutData) else { return nil }
        let data = Unmanaged<CFData>.fromOpaque(layoutData).takeUnretainedValue() as Data
        return character(with: data, keyCode: keyCode, carbonModifiers: carbonModifiers)
    }

    func character(with layoutData: Data, keyCode: Int, carbonModifiers: Int) -> String? {
        // In the case of the special key code, it does not depend on the keyboard layout
        if let specialKeyCode = SpecialKeyCode(keyCode: keyCode) { return specialKeyCode.character }

        let modifierKeyState = (carbonModifiers >> 8) & 0xff
        var deadKeyState: UInt32 = 0
        let maxChars = 256
        var chars = [UniChar](repeating: 0, count: maxChars)
        var length = 0
        let error = layoutData.withUnsafeBytes { pointer -> OSStatus in
            guard let keyboardLayoutPointer = pointer.bindMemory(to: UCKeyboardLayout.self).baseAddress else { return errSecAllocate }
            return CoreServices.UCKeyTranslate(keyboardLayoutPointer,
                                               UInt16(keyCode),
                                               UInt16(CoreServices.kUCKeyActionDisplay),
                                               UInt32(modifierKeyState),
                                               UInt32(LMGetKbdType()),
                                               OptionBits(CoreServices.kUCKeyTranslateNoDeadKeysBit),
                                               &deadKeyState,
                                               maxChars,
                                               &length,
                                               &chars)
        }
        guard error == noErr else { return nil }
        return NSString(characters: &chars, length: length) as String
    }
}
