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
public extension Sauce {
    func currentInputSources() -> [InputSource] {
        return layout.inputSources
    }
}

// MARK: - KeyCodes
public extension Sauce {
    func keyCode(for key: Key, modifiers: SauceModifiers = .none) -> CGKeyCode {
        return currentKeyCode(for: key, modifiers: modifiers) ?? key.QWERTYKeyCode
    }

    func currentKeyCode(for key: Key, modifiers: SauceModifiers = .none) -> CGKeyCode? {
        return layout.currentKeyCode(for: key, carbonModifiers: modifierTransformar.carbonFlags(from: modifiers))
    }

    func currentKeyCodes(modifiers: SauceModifiers = .none) -> [Key: CGKeyCode]? {
        return layout.currentKeyCodes(carbonModifiers: modifierTransformar.carbonFlags(from: modifiers))
    }

    func keyCode(with source: InputSource, key: Key, modifiers: SauceModifiers = .none) -> CGKeyCode? {
        return layout.keyCode(with: source, key: key, carbonModifiers: modifierTransformar.carbonFlags(from: modifiers))
    }

    func keyCodes(with source: InputSource, modifiers: SauceModifiers = .none) -> [Key: CGKeyCode]? {
        return layout.keyCodes(with: source, carbonModifiers: modifierTransformar.carbonFlags(from: modifiers))
    }
}

// MARK: - Key
public extension Sauce {
    func key(for keyCode: Int, modifiers: SauceModifiers = .none) -> Key? {
        return currentKey(for: keyCode, modifiers: modifiers) ?? Key(QWERTYKeyCode: keyCode)
    }

    func currentKey(for keyCode: Int, modifiers: SauceModifiers = .none) -> Key? {
        return layout.currentKey(for: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: modifiers))
    }

    func key(with source: InputSource, keyCode: Int, modifiers: SauceModifiers = .none) -> Key? {
        return layout.key(with: source, keyCode: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: modifiers))
    }
}

// MARK: - Characters
public extension Sauce {
    func character(for keyCode: Int, modifiers: SauceModifiers = .none) -> String? {
        return currentCharacter(for: keyCode, modifiers: modifiers) ?? currentASCIICapableCharacter(for: keyCode, modifiers: modifiers)
    }

    func currentCharacter(for keyCode: Int, modifiers: SauceModifiers = .none) -> String? {
        return layout.currentCharacter(for: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: modifiers))
    }

    func currentASCIICapableCharacter(for keyCode: Int, modifiers: SauceModifiers = .none) -> String? {
        return layout.currentASCIICapableCharacter(for: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: modifiers))
    }

    func character(with source: InputSource, keyCode: Int, modifiers: SauceModifiers = .none) -> String? {
        return layout.character(with: source, keyCode: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: modifiers))
    }
}
#endif
