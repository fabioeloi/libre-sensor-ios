import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(GlucoseTests.allTests),
        testCase(SensorTests.allTests),
        testCase(ReadingTests.allTests),
        testCase(CalibrationInfoTests.allTests),
        testCase(RawTagTests.allTests),
        testCase(NFCManagerTests.allTests),
    ]
}
#endif
