//
//  KeyboardLayout.swift
//
//  Sauce
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015-2020 Clipy Project.
//

import Foundation
import Carbon

final class KeyboardLayout {

    // MARK: - Properties
    private(set) var currentKeyboardLayoutInputSource: InputSource
    private(set) var mappedKeyCodes = [InputSource: [Key: CGKeyCode]]()
    private(set) var inputSources: [InputSource]

    private let distributedNotificationCenter: DistributedNotificationCenter
    private let notificationCenter: NotificationCenter

    // MARK: - Initialize
    init(distributedNotificationCenter: DistributedNotificationCenter = .default(), notificationCenter: NotificationCenter = .default) {
        self.distributedNotificationCenter = distributedNotificationCenter
        self.notificationCenter = notificationCenter
        self.currentKeyboardLayoutInputSource = InputSource(source: TISCopyCurrentKeyboardLayoutInputSource().takeUnretainedValue())
        let tisInputSources = (TISCreateInputSourceList([:] as CFDictionary, false).takeUnretainedValue() as? [TISInputSource]) ?? []
        self.inputSources = tisInputSources.map { InputSource(source: $0) }
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
        /**
         *  Scan key codes
         *
         *  Known issue:
         *  For lauout like Japanese(en), kTISPropertyUnicodeKeyLayoutData returns NULL even if it is ASCIICapableInputSource
         *  Therefore, mapping is not performed when only Japanese is used as a keyboard
         **/
        mappingInputSources()
        mappingKeyCodes(with: currentKeyboardLayoutInputSource)
        observeNotifications()
    }

    deinit {
        distributedNotificationCenter.removeObserver(self)
        notificationCenter.removeObserver(self)
    }

}

// MARK: - KeyCodes
extension KeyboardLayout {
    func currentKeyCodes() -> [Key: CGKeyCode]? {
        return mappedKeyCodes[currentKeyboardLayoutInputSource]
    }

    func currentKeyCode(by key: Key) -> CGKeyCode? {
        return currentKeyCodes()?[key]
    }

    func keyCodes(with source: InputSource) -> [Key: CGKeyCode]? {
        return mappedKeyCodes[source]
    }

    func keyCode(with source: InputSource, key: Key) -> CGKeyCode? {
        return mappedKeyCodes[source]?[key]
    }
}

// MARK: - Characters
extension KeyboardLayout {
    func currentCharacter(by keyCode: Int, carbonModifiers: Int) -> String? {
        return character(with: currentKeyboardLayoutInputSource.source, keyCode: keyCode, carbonModifiers: carbonModifiers)
    }

    func character(with source: InputSource, keyCode: Int, carbonModifiers: Int) -> String? {
        return character(with: source.source, keyCode: keyCode, carbonModifiers: carbonModifiers)
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
        let source = InputSource(source: TISCopyCurrentKeyboardLayoutInputSource().takeUnretainedValue())
        guard source != currentKeyboardLayoutInputSource else { return }
        self.currentKeyboardLayoutInputSource = source
        notificationCenter.post(name: .SauceSelectedKeyboardInputSourceChanged, object: nil)
        guard mappedKeyCodes[source] == nil else { return }
        mappingKeyCodes(with: source)
    }

    @objc func enabledKeyboardInputSourcesChanged() {
        mappedKeyCodes.removeAll()
        mappingInputSources()
        mappingKeyCodes(with: currentKeyboardLayoutInputSource)
        notificationCenter.post(name: .SauceEnabledKeyboardInputSoucesChanged, object: nil)
    }
}

// MAKR: - Layouts
private extension KeyboardLayout {
    func mappingInputSources() {
        guard let sources = TISCreateInputSourceList([:] as CFDictionary, false).takeUnretainedValue() as? [TISInputSource] else { return }
        inputSources = sources.map { InputSource(source: $0) }
        inputSources.forEach { mappingKeyCodes(with: $0) }
    }

    func mappingKeyCodes(with source: InputSource) {
        guard let layoutData = TISGetInputSourceProperty(source.source, kTISPropertyUnicodeKeyLayoutData) else { return }
        let data = Unmanaged<CFData>.fromOpaque(layoutData).takeUnretainedValue() as Data
        var keyCodes = [Key: CGKeyCode]()
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
