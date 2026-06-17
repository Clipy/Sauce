//
//  Deprecated.swift
//
//  Sauce
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015-2026 Clipy Project.
//

#if os(macOS)
import AppKit
import Carbon
import Foundation

// MARK: - Deprecated KeyCodes
extension Sauce {
    @available(*, deprecated, message: "Use keyCode(for:modifiers:) with .carbon(...).")
    public func keyCode(for key: Key, carbonModifiers: Int) -> CGKeyCode {
        return keyCode(for: key, modifiers: .carbon(carbonModifiers))
    }

    @available(*, deprecated, message: "Use keyCode(for:modifiers:) with .cocoa(...).")
    public func keyCode(for key: Key, cocoaModifiers: NSEvent.ModifierFlags) -> CGKeyCode {
        return keyCode(for: key, modifiers: .cocoa(cocoaModifiers))
    }

    @available(*, deprecated, message: "Use currentKeyCode(for:modifiers:) with .carbon(...).")
    public func currentKeyCode(for key: Key, carbonModifiers: Int) -> CGKeyCode? {
        return currentKeyCode(for: key, modifiers: .carbon(carbonModifiers))
    }

    @available(*, deprecated, message: "Use currentKeyCode(for:modifiers:) with .cocoa(...).")
    public func currentKeyCode(for key: Key, cocoaModifiers: NSEvent.ModifierFlags) -> CGKeyCode? {
        return currentKeyCode(for: key, modifiers: .cocoa(cocoaModifiers))
    }

    @available(*, deprecated, message: "Use currentKeyCodes(modifiers:) with .carbon(...).")
    public func currentKeyCodes(carbonModifiers: Int) -> [Key: CGKeyCode]? {
        return currentKeyCodes(modifiers: .carbon(carbonModifiers))
    }

    @available(*, deprecated, message: "Use currentKeyCodes(modifiers:) with .cocoa(...).")
    public func currentKeyCodes(cocoaModifiers: NSEvent.ModifierFlags) -> [Key: CGKeyCode]? {
        return currentKeyCodes(modifiers: .cocoa(cocoaModifiers))
    }

    @available(*, deprecated, message: "Use keyCode(with:key:modifiers:) with .carbon(...).")
    public func keyCode(with source: InputSource, key: Key, carbonModifiers: Int) -> CGKeyCode? {
        return keyCode(with: source, key: key, modifiers: .carbon(carbonModifiers))
    }

    @available(*, deprecated, message: "Use keyCode(with:key:modifiers:) with .cocoa(...).")
    public func keyCode(with source: InputSource, key: Key, cocoaModifiers: NSEvent.ModifierFlags) -> CGKeyCode? {
        return keyCode(with: source, key: key, modifiers: .cocoa(cocoaModifiers))
    }

    @available(*, deprecated, message: "Use keyCodes(with:modifiers:) with .carbon(...).")
    public func keyCodes(with source: InputSource, carbonModifiers: Int) -> [Key: CGKeyCode]? {
        return keyCodes(with: source, modifiers: .carbon(carbonModifiers))
    }

    @available(*, deprecated, message: "Use keyCodes(with:modifiers:) with .cocoa(...).")
    public func keyCodes(with source: InputSource, cocoaModifiers: NSEvent.ModifierFlags) -> [Key: CGKeyCode]? {
        return keyCodes(with: source, modifiers: .cocoa(cocoaModifiers))
    }
}

// MARK: - Deprecated Key
extension Sauce {
    @available(*, deprecated, message: "Use key(for:modifiers:) with .carbon(...).")
    public func key(for keyCode: Int, carbonModifiers: Int) -> Key? {
        return key(for: keyCode, modifiers: .carbon(carbonModifiers))
    }

    @available(*, deprecated, message: "Use key(for:modifiers:) with .cocoa(...).")
    public func key(for keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> Key? {
        return key(for: keyCode, modifiers: .cocoa(cocoaModifiers))
    }

    @available(*, deprecated, message: "Use currentKey(for:modifiers:) with .carbon(...).")
    public func currentKey(for keyCode: Int, carbonModifiers: Int) -> Key? {
        return currentKey(for: keyCode, modifiers: .carbon(carbonModifiers))
    }

    @available(*, deprecated, message: "Use currentKey(for:modifiers:) with .cocoa(...).")
    public func currentKey(for keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> Key? {
        return currentKey(for: keyCode, modifiers: .cocoa(cocoaModifiers))
    }

    @available(*, deprecated, message: "Use key(with:keyCode:modifiers:) with .carbon(...).")
    public func key(with source: InputSource, keyCode: Int, carbonModifiers: Int) -> Key? {
        return key(with: source, keyCode: keyCode, modifiers: .carbon(carbonModifiers))
    }

    @available(*, deprecated, message: "Use key(with:keyCode:modifiers:) with .cocoa(...).")
    public func key(with source: InputSource, keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> Key? {
        return key(with: source, keyCode: keyCode, modifiers: .cocoa(cocoaModifiers))
    }
}

// MARK: - Deprecated Characters
extension Sauce {
    @available(*, deprecated, message: "Use character(for:modifiers:) with .carbon(...).")
    public func character(for keyCode: Int, carbonModifiers: Int) -> String? {
        return character(for: keyCode, modifiers: .carbon(carbonModifiers))
    }

    @available(*, deprecated, message: "Use character(for:modifiers:) with .cocoa(...).")
    public func character(for keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> String? {
        return character(for: keyCode, modifiers: .cocoa(cocoaModifiers))
    }

    @available(*, deprecated, message: "Use currentCharacter(for:modifiers:) with .carbon(...).")
    public func currentCharacter(for keyCode: Int, carbonModifiers: Int) -> String? {
        return currentCharacter(for: keyCode, modifiers: .carbon(carbonModifiers))
    }

    @available(*, deprecated, message: "Use currentCharacter(for:modifiers:) with .cocoa(...).")
    public func currentCharacter(for keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> String? {
        return currentCharacter(for: keyCode, modifiers: .cocoa(cocoaModifiers))
    }

    @available(*, deprecated, message: "Use currentASCIICapableCharacter(for:modifiers:) with .carbon(...).")
    public func currentASCIICapableCharacter(for keyCode: Int, carbonModifiers: Int) -> String? {
        return currentASCIICapableCharacter(for: keyCode, modifiers: .carbon(carbonModifiers))
    }

    @available(*, deprecated, message: "Use currentASCIICapableCharacter(for:modifiers:) with .cocoa(...).")
    public func currentASCIICapableCharacter(for keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> String? {
        return currentASCIICapableCharacter(for: keyCode, modifiers: .cocoa(cocoaModifiers))
    }

    @available(*, deprecated, message: "Use character(with:keyCode:modifiers:) with .carbon(...).")
    public func character(with source: InputSource, keyCode: Int, carbonModifiers: Int) -> String? {
        return character(with: source, keyCode: keyCode, modifiers: .carbon(carbonModifiers))
    }

    @available(*, deprecated, message: "Use character(with:keyCode:modifiers:) with .cocoa(...).")
    public func character(with source: InputSource, keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> String? {
        return character(with: source, keyCode: keyCode, modifiers: .cocoa(cocoaModifiers))
    }
}
#endif
