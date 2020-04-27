// 
//  ModifierTransformer.swift
//
//  Sauce
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
// 
//  Copyright © 2015-2020 Clipy Project.
//

import Foundation
import Carbon

final class ModifierTransformer {}

// MARK: - Cocoa & Carbon
extension ModifierTransformer {
    func carbonFlags(from cocoaFlags: NSEvent.ModifierFlags) -> Int {
        var carbonFlags: Int = 0
        if cocoaFlags.contains(.command) {
            carbonFlags |= cmdKey
        }
        if cocoaFlags.contains(.option) {
            carbonFlags |= optionKey
        }
        if cocoaFlags.contains(.control) {
            carbonFlags |= controlKey
        }
        if cocoaFlags.contains(.shift) {
            carbonFlags |= shiftKey
        }
        return carbonFlags
    }
}
