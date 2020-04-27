//
//  Sauce.swift
//
//  Sauce
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015-2020 Clipy Project.
//

import Foundation
import AppKit

public extension NSNotification.Name {
    static let SauceSelectedKeyboardInputSourceChanged = Notification.Name("SauceSelectedKeyboardInputSourceChanged")
    static let SauceEnabledKeyboardInputSoucesChanged = Notification.Name("SauceEnabledKeyboardInputSoucesChanged")
}

public final class Sauce {

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

// MARK: - KeyCodes
public extension Sauce {
    func keyCode(by key: Key) -> CGKeyCode {
        return currentKeyCode(by: key) ?? currentASCIICapableKeyCode(by: key) ?? key.QWERTYKeyCode
    }

    func currentKeyCode(by key: Key) -> CGKeyCode? {
        return layout.currentKeyCode(by: key)
    }

    func currentASCIICapableKeyCode(by key: Key) -> CGKeyCode? {
        return layout.currentASCIICapableKeyCode(by: key)
    }

    func keyCode(with source: InputSource, key: Key) -> CGKeyCode? {
        return layout.keyCode(with: source, key: key)
    }

    func ASCIICapableInputSources() -> [InputSource] {
        return layout.ASCIICapableInputSources
    }
}

// MARK: - Characters
public extension Sauce {
    func character(by keyCode: Int, carbonModifiers: Int) -> String? {
        return currentCharacter(by: keyCode, carbonModifiers: carbonModifiers) ?? currentASCIICapableCharacter(by: keyCode, carbonModifiers: carbonModifiers)
    }

    func character(by keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> String? {
        return currentCharacter(by: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers)) ?? currentASCIICapableCharacter(by: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }

    func currentCharacter(by keyCode: Int, carbonModifiers: Int) -> String? {
        return layout.currentCharacter(by: keyCode, carbonModifiers: carbonModifiers)
    }

    func currentCharacter(by keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> String? {
        return layout.currentCharacter(by: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }

    func currentASCIICapableCharacter(by keyCode: Int, carbonModifiers: Int) -> String? {
        return layout.currentASCIICapableCharacter(by: keyCode, carbonModifiers: carbonModifiers)
    }

    func currentASCIICapableCharacter(by keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> String? {
        return layout.currentASCIICapableCharacter(by: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }

    func character(with source: InputSource, keyCode: Int, carbonModifiers: Int) -> String? {
        return layout.character(with: source, keyCode: keyCode, carbonModifiers: carbonModifiers)
    }

    func character(with source: InputSource, keyCode: Int, cocoaModifiers: NSEvent.ModifierFlags) -> String? {
        return layout.character(with: source, keyCode: keyCode, carbonModifiers: modifierTransformar.carbonFlags(from: cocoaModifiers))
    }
}
