//
//  Sauce.swift
//
//  Sauce
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015-2020 Clipy Project.
//

#if os(macOS)
import AppKit
import Carbon
import Foundation

public extension NSNotification.Name {
    static let SauceSelectedKeyboardInputSourceChanged = Notification.Name("SauceSelectedKeyboardInputSourceChanged")
    static let SauceEnabledKeyboardInputSourcesChanged = Notification.Name("SauceEnabledKeyboardInputSourcesChanged")
    static let SauceSelectedKeyboardKeyCodesChanged = Notification.Name("SauceSelectedKeyboardKeyCodesChanged")
}

open class Sauce {
    // MARK: - Properties
    public static let shared = Sauce()

    private let layout: KeyboardLayout
    private let modifierTransformar: ModifierTransformer

    // MARK: - Initialize
    init(layout: KeyboardLayout = KeyboardLayout(), modifierTransformar: ModifierTransformer = ModifierTransformer()) {
        self.layout = layout
        self.modifierTransformar = modifierTransformar
    }
}

// MARK: - Input Sources
extension Sauce {
    public func currentInputSources() -> [InputSource] {
        return layout.inputSources
    }
}

// MARK: - KeyCodes
extension Sauce {
    public func keyCode(for key: Key, carbonModifiers: Int = 0) -> CGKeyCode {
        return currentKeyCode(for: key, carbonModifiers: carbonModifiers) ?? key.QWERTYKeyCode
    }

    public func keyCode(for key: Key, cocoaModifiers: NSEvent.ModifierFlags) -> CGKeyCode {
        return keyCode(for: key, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }

    public func currentKeyCode(for key: Key, carbonModifiers: Int = 0) -> CGKeyCode? {
        return layout.currentKeyCode(for: key, carbonModifiers: carbonModifiers)
    }

    public func currentKeyCode(for key: Key, cocoaModifiers: NSEvent.ModifierFlags) -> CGKeyCode? {
        return currentKeyCode(for: key, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }

    public func currentKeyCodes(carbonModifiers: Int = 0) -> [Key: CGKeyCode]? {
        return layout.currentKeyCodes(carbonModifiers: carbonModifiers)
    }

    public func currentKeyCodes(cocoaModifiers: NSEvent.ModifierFlags) -> [Key: CGKeyCode]? {
        return currentKeyCodes(carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }

    public func keyCode(with source: InputSource, key: Key, carbonModifiers: Int = 0) -> CGKeyCode? {
        return layout.keyCode(with: source, key: key, carbonModifiers: carbonModifiers)
    }

    public func keyCode(with source: InputSource, key: Key, cocoaModifiers: NSEvent.ModifierFlags) -> CGKeyCode? {
        return keyCode(with: source, key: key, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }

    public func keyCodes(with source: InputSource, carbonModifiers: Int = 0) -> [Key: CGKeyCode]? {
        return layout.keyCodes(with: source, carbonModifiers: carbonModifiers)
    }

    public func keyCodes(with source: InputSource, cocoaModifiers: NSEvent.ModifierFlags) -> [Key: CGKeyCode]? {
        return keyCodes(with: source, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }
}

// MARK: - Key
extension Sauce {
    public func key(for keyCode: Int, carbonModifiers: Int = 0) -> Key? {
        return currentKey(for: keyCode, carbonModifiers: carbonModifiers) ?? Key(QWERTYKeyCode: keyCode)
    }

    public func key(for keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> Key? {
        return key(for: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }

    public func currentKey(for keyCode: Int, carbonModifiers: Int = 0) -> Key? {
        return layout.currentKey(for: keyCode, carbonModifiers: carbonModifiers)
    }

    public func currentKey(for keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> Key? {
        return currentKey(for: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }

    public func key(with source: InputSource, keyCode: Int, carbonModifiers: Int = 0) -> Key? {
        return layout.key(with: source, keyCode: keyCode, carbonModifiers: carbonModifiers)
    }

    public func key(with source: InputSource, keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> Key? {
        return key(with: source, keyCode: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }
}

// MARK: - Characters
extension Sauce {
    public func character(for keyCode: Int, carbonModifiers: Int) -> String? {
        return currentCharacter(for: keyCode, carbonModifiers: carbonModifiers) ?? currentASCIICapableCharacter(for: keyCode, carbonModifiers: carbonModifiers)
    }

    public func character(for keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> String? {
        return character(for: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }

    public func currentCharacter(for keyCode: Int, carbonModifiers: Int) -> String? {
        return layout.currentCharacter(for: keyCode, carbonModifiers: carbonModifiers)
    }

    public func currentCharacter(for keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> String? {
        return currentCharacter(for: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }

    public func currentASCIICapableCharacter(for keyCode: Int, carbonModifiers: Int) -> String? {
        return layout.currentASCIICapableCharacter(for: keyCode, carbonModifiers: carbonModifiers)
    }

    public func currentASCIICapableCharacter(for keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> String? {
        return currentASCIICapableCharacter(for: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }

    public func character(with source: InputSource, keyCode: Int, carbonModifiers: Int) -> String? {
        return layout.character(with: source, keyCode: keyCode, carbonModifiers: carbonModifiers)
    }

    public func character(with source: InputSource, keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> String? {
        return character(with: source, keyCode: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }
}
#endif
