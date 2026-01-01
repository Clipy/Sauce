import Carbon
@testable import Sauce

extension InputSource {
    static var enabledInputSources: [InputSource] {
        let sourceList = TISCreateInputSourceList([:] as CFDictionary, false)
            .takeUnretainedValue() as? [TISInputSource]
        return sourceList?.map { InputSource(source: $0) } ?? []
    }

    static var allInputSources: [InputSource] {
        let sourceList = TISCreateInputSourceList([:] as CFDictionary, true)
            .takeUnretainedValue() as? [TISInputSource]
        return sourceList?.map { InputSource(source: $0) } ?? []
    }

    func enable() -> Bool {
        TISEnableInputSource(source) == noErr
    }

    @discardableResult
    func disable() -> Bool {
        TISDisableInputSource(source) == noErr
    }

    @discardableResult
    func select() -> Bool {
        TISSelectInputSource(source) == noErr
    }
}
