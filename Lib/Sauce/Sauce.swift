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
import Foundation
import AppKit

extension NSNotification.Name {
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
    public func keyCode(for key: Key) -> CGKeyCode {
        return currentKeyCode(for: key) ?? key.QWERTYKeyCode
    }

    public func currentKeyCode(for key: Key) -> CGKeyCode? {
        return layout.currentKeyCode(for: key)
    }

    public func currentKeyCodes() -> [Key: CGKeyCode]? {
        return layout.currentKeyCodes()
    }

    public func keyCode(with source: InputSource, key: Key) -> CGKeyCode? {
        return layout.keyCode(with: source, key: key)
    }

    public func keyCodes(with source: InputSource) -> [Key: CGKeyCode]? {
        return layout.keyCodes(with: source)
    }
}

// MARK: - Key
extension Sauce {
    public func key(for keyCode: Int) -> Key? {
        return currentKey(for: keyCode) ?? Key(QWERTYKeyCode: keyCode)
    }

    public func currentKey(for keyCode: Int) -> Key? {
        return layout.currentKey(for: keyCode)
    }

    public func key(with source: InputSource, keyCode: Int) -> Key? {
        return layout.key(with: source, keyCode: keyCode)
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
