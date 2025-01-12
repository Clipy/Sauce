// 
//  KeyModifier.swift
//
//  Sauce
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
// 
//  Copyright © 2015-2025 Clipy Project.
//

import Carbon

internal enum KeyModifier: CaseIterable {
    case none
    /// State when the ⌘ key is pressed
    /// Supports keyboard that change key layout when ⌘ is pressd, such as `Dvorak - QWERTY ⌘`
    case withCommand

    // MARK: - Initialize
    init(carbonModifiers: Int) {
        if (carbonModifiers & cmdKey) != 0 {
            self = .withCommand
        } else {
            self = .none
        }
    }

    // MARK: - Properties
    var carbonModifier: Int {
        switch self {
        case .none:
            return 0
        case .withCommand:
            return cmdKey
        }
    }
}
