// 
//  KeyMappingModifiers.swift
//
//  Sauce
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
// 
//  Copyright © 2015-2025 Clipy Project.
//

import Carbon

internal enum KeyMappingModifiers: CaseIterable {
    case unmodified
    /// State when the ⌘ key is pressed
    /// Supports keyboard that change key layout when ⌘ is pressd, such as `Dvorak - QWERTY ⌘`
    case withCommand

    // MARK: - Initialize
    init(carbonModifiers: Int) {
        if (carbonModifiers & cmdKey) != 0 {
            self = .withCommand
        } else {
            self = .unmodified
        }
    }

    // MARK: - Properties
    var carbonModifier: Int {
        switch self {
        case .unmodified:
            return 0
        case .withCommand:
            return cmdKey
        }
    }
}
