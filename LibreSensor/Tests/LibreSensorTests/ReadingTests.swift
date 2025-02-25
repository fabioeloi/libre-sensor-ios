import XCTest
@testable import LibreSensor

final class ReadingTests: XCTestCase {
    var reading: Reading!
    var calibrationInfo: CalibrationInfo!
    
    override func setUp() {
        super.setUp()
        reading = Reading(rawValue: 1000, timestamp: Date())
        calibrationInfo = CalibrationInfo(i1: 1.0, i2: 2.0, i3: 3.0, i4: 4.0, i5: 5.0, i6: 6.0)
    }
    
    func testReadingInitialization() {
        XCTAssertNotNil(reading)
        XCTAssertEqual(reading.rawValue, 1000)
        XCTAssertNotNil(reading.timestamp)
    }
    
    func testGlucoseCalculation() {
        let glucose = reading.getGlucose(calibrationInfo: calibrationInfo)
        XCTAssertNotNil(glucose)
        XCTAssertGreaterThan(glucose.value, 0)
    }
    
    func testTimestampAccuracy() {
        let now = Date()
        let reading = Reading(rawValue: 1000, timestamp: now)
        XCTAssertEqual(reading.timestamp.timeIntervalSince1970, 
                      now.timeIntervalSince1970, 
                      accuracy: 0.001)
    }
    
    func testMultipleReadings() {
        let readings = [
            Reading(rawValue: 1000, timestamp: Date()),
            Reading(rawValue: 1100, timestamp: Date().addingTimeInterval(300)),
            Reading(rawValue: 1200, timestamp: Date().addingTimeInterval(600))
        ]
        
        var lastGlucose: Double = 0
        for reading in readings {
            let glucose = reading.getGlucose(calibrationInfo: calibrationInfo)
            XCTAssertGreaterThan(glucose.value, lastGlucose)
            lastGlucose = glucose.value
        }
    }
}
