import XCTest
@testable import LibreSensor

final class CalibrationInfoTests: XCTestCase {
    var calibrationInfo: CalibrationInfo!
    
    override func setUp() {
        super.setUp()
        calibrationInfo = CalibrationInfo(
            i1: 1.0,
            i2: 2.0,
            i3: 3.0,
            i4: 4.0,
            i5: 5.0,
            i6: 6.0
        )
    }
    
    func testCalibrationInfoInitialization() {
        XCTAssertNotNil(calibrationInfo)
        XCTAssertEqual(calibrationInfo.i1, 1.0)
        XCTAssertEqual(calibrationInfo.i2, 2.0)
        XCTAssertEqual(calibrationInfo.i3, 3.0)
        XCTAssertEqual(calibrationInfo.i4, 4.0)
        XCTAssertEqual(calibrationInfo.i5, 5.0)
        XCTAssertEqual(calibrationInfo.i6, 6.0)
    }
    
    func testCalibration() {
        let rawValues = [0, 100, 500, 1000, 2000]
        
        for rawValue in rawValues {
            let calibratedValue = calibrationInfo.calibrate(rawValue: rawValue)
            XCTAssertNotNil(calibratedValue)
            XCTAssertGreaterThanOrEqual(calibratedValue, 0)
        }
    }
    
    func testCalibrationConsistency() {
        let rawValue = 1000
        let firstCalibration = calibrationInfo.calibrate(rawValue: rawValue)
        let secondCalibration = calibrationInfo.calibrate(rawValue: rawValue)
        
        XCTAssertEqual(firstCalibration, secondCalibration)
    }
}
