//
//  SauceModifiers.swift
//
//  Sauce
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015-2026 Clipy Project.
//

#if os(macOS)
import AppKit
import Foundation

public enum SauceModifiers {
    case carbon(Int)
    case cocoa(NSEvent.ModifierFlags)

    public static let none: SauceModifiers = .carbon(0)
}

extension ModifierTransformer {
    func carbonFlags(from modifiers: SauceModifiers) -> Int {
        switch modifiers {
        case let .carbon(carbonModifiers):
            return carbonModifiers
        case let .cocoa(cocoaModifiers):
            return carbonFlags(from: cocoaModifiers)
        }
    }
}
#endif
