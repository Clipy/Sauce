//
//  InputSourceTrait.swift
//
//  SauceTests
//  GitHub: https://github.com/clipy
//  HP: https://clipy-app.com
//
//  Copyright © 2015 Clipy Project.
//

import Carbon
import Testing
@testable import Sauce

@MainActor
struct InputSourceTrait: TestTrait, TestScoping {
    let enableIDs: [String]
    let selectIDs: [String]

    func provideScope(
        for test: Test,
        testCase: Test.Case?,
        performing function: () async throws -> Void
    ) async throws {
        let selectedInputSource = InputSource(source: TISCopyCurrentKeyboardLayoutInputSource().takeUnretainedValue())
        let allInputSources = InputSource.allInputSources
        let enabledInputSources = InputSource.enabledInputSources
        let enableInputSources = try enableIDs.map { id in
            try #require(allInputSources.first { $0.id == id })
        }
        let selectInputSources = try selectIDs.map { id in
            try #require(allInputSources.first { $0.id == id })
        }
        let disableInputSources = enabledInputSources.filter { inputSource in
            !enableIDs.contains(inputSource.id)
        }

        enableInputSources.forEach { inputSource in
            #expect(inputSource.enable())
        }
        selectInputSources.forEach { inputSource in
            #expect(inputSource.select())
        }
        disableInputSources.forEach { inputSource in
            #expect(inputSource.disable())
        }

        defer {
            InputSource.enabledInputSources.filter { !enabledInputSources.contains($0) }
                .forEach { $0.disable() }
            enabledInputSources
                .forEach { $0.enable() }
            selectedInputSource.select()
        }

        try await function()
    }
}

extension Trait where Self == InputSourceTrait {
    static func inputSource(
        enableIDs: [String] = [],
        selectIDs: [String] = []
    ) -> InputSourceTrait {
        InputSourceTrait(enableIDs: enableIDs, selectIDs: selectIDs)
    }
}
