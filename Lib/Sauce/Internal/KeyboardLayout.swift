//
//  KeyboardLayout.swift
//
//  Sauce
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015-2020 Clipy Project.
//

#if os(macOS)
import Carbon
import Foundation

internal final class KeyboardLayout {
    // MARK: - Properties
    private var currentKeyboardLayoutInputSource: InputSource
    private var currentASCIICapableInputSource: InputSource
    private var mappedKeyCodes = [InputSource: [KeyModifier: [Key: CGKeyCode]]]()
    private(set) var inputSources = [InputSource]()

    private let distributedNotificationCenter: DistributedNotificationCenter
    private let notificationCenter: NotificationCenter
    private let modifierTransformer: ModifierTransformer

    // MARK: - Initialize
    init(distributedNotificationCenter: DistributedNotificationCenter = .default(), notificationCenter: NotificationCenter = .default, modifierTransformer: ModifierTransformer = ModifierTransformer()) {
        self.distributedNotificationCenter = distributedNotificationCenter
        self.notificationCenter = notificationCenter
        self.modifierTransformer = modifierTransformer
        self.currentKeyboardLayoutInputSource = InputSource(source: TISCopyCurrentKeyboardLayoutInputSource().takeUnretainedValue())
        self.currentASCIICapableInputSource = InputSource(source: TISCopyCurrentASCIICapableKeyboardInputSource().takeUnretainedValue())
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
internal extension KeyboardLayout {
    func currentKeyCodes(carbonModifiers: Int) -> [Key: CGKeyCode]? {
        return keyCodes(with: currentKeyboardLayoutInputSource, carbonModifiers: carbonModifiers)
    }

    func currentKeyCode(for key: Key, carbonModifiers: Int) -> CGKeyCode? {
        return keyCode(with: currentKeyboardLayoutInputSource, key: key, carbonModifiers: carbonModifiers)
    }

    func keyCodes(with source: InputSource, carbonModifiers: Int) -> [Key: CGKeyCode]? {
        return mappedKeyCodes[source]?[.init(carbonModifiers: carbonModifiers)]
    }

    func keyCode(with source: InputSource, key: Key, carbonModifiers: Int) -> CGKeyCode? {
        return mappedKeyCodes[source]?[.init(carbonModifiers: carbonModifiers)]?[key]
    }
}

// MARK: - Key
internal extension KeyboardLayout {
    func currentKey(for keyCode: Int, carbonModifiers: Int) -> Key? {
        return key(with: currentKeyboardLayoutInputSource, keyCode: keyCode, carbonModifiers: carbonModifiers)
    }

    func key(with source: InputSource, keyCode: Int, carbonModifiers: Int) -> Key? {
        return mappedKeyCodes[source]?[.init(carbonModifiers: carbonModifiers)]?.first(where: { $0.value == CGKeyCode(keyCode) })?.key
    }
}

// MARK: - Characters
internal extension KeyboardLayout {
    func currentCharacter(for keyCode: Int, carbonModifiers: Int) -> String? {
        return character(with: currentKeyboardLayoutInputSource, keyCode: keyCode, carbonModifiers: carbonModifiers)
    }

    func currentASCIICapableCharacter(for keyCode: Int, carbonModifiers: Int) -> String? {
        return character(with: currentASCIICapableInputSource, keyCode: keyCode, carbonModifiers: carbonModifiers)
    }

    func character(with source: InputSource, keyCode: Int, carbonModifiers: Int) -> String? {
        return character(with: source.source, keyCode: keyCode, carbonModifiers: carbonModifiers)
    }
}

// MARK: - Notifications
internal extension KeyboardLayout {
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
        self.currentASCIICapableInputSource = InputSource(source: TISCopyCurrentASCIICapableKeyboardInputSource().takeUnretainedValue())
        guard source != currentKeyboardLayoutInputSource else { return }
        let previousKeyboardLayoutInputSource = currentKeyboardLayoutInputSource
        self.currentKeyboardLayoutInputSource = source
        guard mappedKeyCodes[source] == nil else {
            notificationCenter.post(name: .SauceSelectedKeyboardInputSourceChanged, object: nil)
            notifyKeyCodesChangedIfNeeded(previous: previousKeyboardLayoutInputSource, current: source)
            return
        }
        mappingKeyCodes(with: source)
        notificationCenter.post(name: .SauceSelectedKeyboardInputSourceChanged, object: nil)
        notifyKeyCodesChangedIfNeeded(previous: previousKeyboardLayoutInputSource, current: source)
    }

    @objc func enabledKeyboardInputSourcesChanged() {
        mappedKeyCodes.removeAll()
        mappingInputSources()
        mappingKeyCodes(with: currentKeyboardLayoutInputSource)
        notificationCenter.post(name: .SauceEnabledKeyboardInputSourcesChanged, object: nil)
    }

    private func notifyKeyCodesChangedIfNeeded(previous: InputSource, current: InputSource) {
        guard let previousKeyCodes = mappedKeyCodes[previous] else { return }
        guard let currentKeyCodes = mappedKeyCodes[current] else { return }
        guard previousKeyCodes != currentKeyCodes else { return }
        notificationCenter.post(name: .SauceSelectedKeyboardKeyCodesChanged, object: nil)
    }
}

// MARK: - Layouts
private extension KeyboardLayout {
    func mappingInputSources() {
        guard let sources = TISCreateInputSourceList([:] as CFDictionary, false).takeUnretainedValue() as? [TISInputSource] else { return }
        inputSources = sources.map { InputSource(source: $0) }
        inputSources.forEach { mappingKeyCodes(with: $0) }
    }

    func mappingKeyCodes(with source: InputSource) {
        guard let layoutData = TISGetInputSourceProperty(source.source, kTISPropertyUnicodeKeyLayoutData) else { return }
        let data = Unmanaged<CFData>.fromOpaque(layoutData).takeUnretainedValue() as Data
        var codes = [KeyModifier: [Key: CGKeyCode]]()
        KeyModifier.allCases.forEach { keyModifier in
            var keyCodes = [Key: CGKeyCode]()
            for i in 0..<128 {
                guard let character = character(with: data, keyCode: i, carbonModifiers: keyModifier.carbonModifier) else { continue }
                guard let key = Key(character: character, virtualKeyCode: i) else { continue }
                guard keyCodes[key] == nil else { continue }
                keyCodes[key] = CGKeyCode(i)
            }
            codes[keyModifier] = keyCodes
        }
        mappedKeyCodes[source] = codes
    }

    func character(with source: TISInputSource, keyCode: Int, carbonModifiers: Int) -> String? {
        guard let layoutData = TISGetInputSourceProperty(source, kTISPropertyUnicodeKeyLayoutData) else { return nil }
        let data = Unmanaged<CFData>.fromOpaque(layoutData).takeUnretainedValue() as Data
        let keyModifier = KeyModifier(carbonModifiers: carbonModifiers)
        var carbonModifiers = modifierTransformer.convertCharactorSupportCarbonModifiers(from: carbonModifiers)
        switch keyModifier {
        case .none:
            return character(with: data, keyCode: keyCode, carbonModifiers: carbonModifiers)
        case .withCommand:
            /// Determines if it's a special keyboard environment by comparing the string output with and without the ⌘ key pressed
            /// For example, with a `Dvorak - QWERTY ⌘` keyboard, entering keycode `47` returns different characters depending on whether the ⌘ key pressed or not
            /// ⌘ not pressed: `v`
            /// ⌘ pressed: `.` (same as entering keycode `47` on a QWERTY keyboard)
            let noCommandCharacter = character(with: data, keyCode: keyCode, carbonModifiers: 0)
            let commandCharacter = character(with: data, keyCode: keyCode, carbonModifiers: cmdKey)
            guard noCommandCharacter != commandCharacter else {
                /// If the outputs are the same, it's a regular keyboard, so return the string excluding the ⌘ key
                return character(with: data, keyCode: keyCode, carbonModifiers: carbonModifiers)
            }
            /// Workaround: To get a string with modifiers other than ⌘ key working, obtain the keycode for the standard key layout and generate the string
            guard let commandCharacter,
                  let key = Key(character: commandCharacter, virtualKeyCode: keyCode),
                  let keyCode = mappedKeyCodes[.init(source: source)]?[.none]?.first(where: { $0.key == key })?.value
            else {
                /// If mapping is not possible, ignore modifiers other than ⌘ and return a value as close as possible to the key input
                carbonModifiers |= cmdKey
                return character(with: data, keyCode: keyCode, carbonModifiers: carbonModifiers)
            }
            return character(with: data, keyCode: Int(keyCode), carbonModifiers: carbonModifiers)
        }
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
#endif
