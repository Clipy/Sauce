import Testing
@testable import Sauce

@MainActor
struct InputSourceTrait: TestTrait, TestScoping {
    let enableIDs: [String]
    let selectIDs: [String]
    let disableIDs: [String]

    func provideScope(
        for test: Test,
        testCase: Test.Case?,
        performing function: () async throws -> Void
    ) async throws {
        let allInputSources = InputSource.allInputSources
        let enabledInputSources = InputSource.enabledInputSources
        let enableInputSources = try enableIDs.map { id in
            try #require(allInputSources.first { $0.id == id })
        }
        let selectInputSources = try selectIDs.map { id in
            try #require(allInputSources.first { $0.id == id })
        }
        let disableInputSources = try disableIDs.map { id in
            try #require(allInputSources.first { $0.id == id })
        }

        let deferDisabledInputSources = enableInputSources.filter { inputSource in
            enabledInputSources.map(\.id).contains(inputSource.id) == false
        }
        let deferEnabledInputSources = disableInputSources.filter { inputSource in
            enabledInputSources.map(\.id).contains(inputSource.id) == true
        }
        defer {
            deferEnabledInputSources.forEach { inputSource in
                #expect(inputSource.enable())
            }
            deferDisabledInputSources.forEach { inputSource in
                #expect(inputSource.disable())
            }
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

        try await function()
    }
}

extension Trait where Self == InputSourceTrait {
    static func inputSource(
        enableIDs: [String] = [],
        selectIDs: [String] = [],
        disableIDs: [String] = []
    ) -> InputSourceTrait {
        InputSourceTrait(enableIDs: enableIDs, selectIDs: selectIDs, disableIDs: disableIDs)
    }
}
