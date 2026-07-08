//
//  SpecialKeyCode.swift
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

// swiftlint:disable identifier_name function_body_length type_body_length

/**
 *  keycodes for keys that are independent of keyboard layout
 *  ref: Carbon.framework
 *
 *  UCKeyTranslate can not convert a layout-independent keycode to string.
 **/
internal enum SpecialKeyCode: CaseIterable {
    case `return`
    case tab
    case space
    case delete
    case escape
    case f17
    case f18
    case f19
    case f20
    case f5
    case f6
    case f7
    case f3
    case f8
    case f9
    case f11
    case f13
    case f16
    case f14
    case f10
    case f12
    case f15
    case help
    case home
    case pageUp
    case forwardDelete
    case f4
    case end
    case f2
    case pageDown
    case f1
    case leftArrow
    case rightArrow
    case downArrow
    case upArrow
    case eisu
    case kana
    case keypadClear
    case keypadEnter

    // MARK: - Initialize
    init?(keyCode: Int) {
        switch keyCode {
        case kVK_Return:
            self = .return
        case kVK_Tab:
            self = .tab
        case kVK_Space:
            self = .space
        case kVK_Delete:
            self = .delete
        case kVK_Escape:
            self = .escape
        case kVK_F17:
            self = .f17
        case kVK_F18:
            self = .f18
        case kVK_F19:
            self = .f19
        case kVK_F20:
            self = .f20
        case kVK_F5:
            self = .f5
        case kVK_F6:
            self = .f6
        case kVK_F7:
            self = .f7
        case kVK_F3:
            self = .f3
        case kVK_F8:
            self = .f8
        case kVK_F9:
            self = .f9
        case kVK_F11:
            self = .f11
        case kVK_F13:
            self = .f13
        case kVK_F16:
            self = .f16
        case kVK_F14:
            self = .f14
        case kVK_F10:
            self = .f10
        case kVK_F12:
            self = .f12
        case kVK_F15:
            self = .f15
        case kVK_Help:
            self = .help
        case kVK_Home:
            self = .home
        case kVK_PageUp:
            self = .pageUp
        case kVK_ForwardDelete:
            self = .forwardDelete
        case kVK_F4:
            self = .f4
        case kVK_End:
            self = .end
        case kVK_F2:
            self = .f2
        case kVK_PageDown:
            self = .pageDown
        case kVK_F1:
            self = .f1
        case kVK_LeftArrow:
            self = .leftArrow
        case kVK_RightArrow:
            self = .rightArrow
        case kVK_DownArrow:
            self = .downArrow
        case kVK_UpArrow:
            self = .upArrow
        case kVK_JIS_Eisu:
            self = .eisu
        case kVK_JIS_Kana:
            self = .kana
        case kVK_ANSI_KeypadClear:
            self = .keypadClear
        case kVK_ANSI_KeypadEnter:
            self = .keypadEnter
        default:
            return nil
        }
    }

    // MARK: - Properties
    var character: String {
        switch self {
        case .return:
            return "↩"
        case .tab:
            return "⇥"
        case .space:
            return "␣"
        case .delete:
            return "⌫"
        case .escape:
            return "⎋"
        case .f17:
            return "F17"
        case .f18:
            return "F18"
        case .f19:
            return "F19"
        case .f20:
            return "F20"
        case .f5:
            return "F5"
        case .f6:
            return "F6"
        case .f7:
            return "F7"
        case .f3:
            return "F3"
        case .f8:
            return "F8"
        case .f9:
            return "F9"
        case .f11:
            return "F11"
        case .f13:
            return "F13"
        case .f16:
            return "F16"
        case .f14:
            return "F14"
        case .f10:
            return "F10"
        case .f12:
            return "F12"
        case .f15:
            return "F15"
        case .help:
            return "?⃝"
        case .home:
            return "↖"
        case .pageUp:
            return "⇞"
        case .forwardDelete:
            return "⌦"
        case .f4:
            return "F4"
        case .end:
            return "↘"
        case .f2:
            return "F2"
        case .pageDown:
            return "⇟"
        case .f1:
            return "F1"
        case .leftArrow:
            return "←"
        case .rightArrow:
            return "→"
        case .downArrow:
            return "↓"
        case .upArrow:
            return "↑"
        case .eisu:
            return "英数"
        case .kana:
            return "かな"
        case .keypadClear:
            return "⌧"
        case .keypadEnter:
            return "⌅"
        }
    }
    var appKitKeyEquivalents: [String] {
        let characters: [Int]
        switch self {
        case .return:
            characters = [NSNewlineCharacter, NSCarriageReturnCharacter]
        case .tab:
            characters = [NSTabCharacter, NSBackTabCharacter]
        case .delete:
            characters = [NSBackspaceCharacter, NSDeleteCharacter]
        case .f17:
            characters = [NSF17FunctionKey]
        case .f18:
            characters = [NSF18FunctionKey]
        case .f19:
            characters = [NSF19FunctionKey]
        case .f20:
            characters = [NSF20FunctionKey]
        case .f5:
            characters = [NSF5FunctionKey]
        case .f6:
            characters = [NSF6FunctionKey]
        case .f7:
            characters = [NSF7FunctionKey]
        case .f3:
            characters = [NSF3FunctionKey]
        case .f8:
            characters = [NSF8FunctionKey]
        case .f9:
            characters = [NSF9FunctionKey]
        case .f11:
            characters = [NSF11FunctionKey]
        case .f13:
            characters = [NSF13FunctionKey]
        case .f16:
            characters = [NSF16FunctionKey]
        case .f14:
            characters = [NSF14FunctionKey]
        case .f10:
            characters = [NSF10FunctionKey]
        case .f12:
            characters = [NSF12FunctionKey]
        case .f15:
            characters = [NSF15FunctionKey]
        case .help:
            characters = [NSHelpFunctionKey]
        case .home:
            characters = [NSHomeFunctionKey]
        case .pageUp:
            characters = [NSPageUpFunctionKey]
        case .forwardDelete:
            characters = [NSDeleteFunctionKey]
        case .f4:
            characters = [NSF4FunctionKey]
        case .end:
            characters = [NSEndFunctionKey]
        case .f2:
            characters = [NSF2FunctionKey]
        case .pageDown:
            characters = [NSPageDownFunctionKey]
        case .f1:
            characters = [NSF1FunctionKey]
        case .leftArrow:
            characters = [NSLeftArrowFunctionKey]
        case .rightArrow:
            characters = [NSRightArrowFunctionKey]
        case .downArrow:
            characters = [NSDownArrowFunctionKey]
        case .upArrow:
            characters = [NSUpArrowFunctionKey]
        case .keypadClear:
            characters = [NSClearLineFunctionKey]
        case .keypadEnter:
            characters = [NSEnterCharacter]
        case .space, .escape, .eisu, .kana:
            characters = []
        }
        return characters.compactMap { UnicodeScalar($0) }
            .map { String($0) }
    }
}
#endif
