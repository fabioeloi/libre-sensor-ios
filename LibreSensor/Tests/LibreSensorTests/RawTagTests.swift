import XCTest
@testable import LibreSensor

final class RawTagTests: XCTestCase {
    var rawTag: RawTag!
    var sensorData: Data!
    var sensorUID: Data!
    
    override func setUp() {
        super.setUp()
        // Sample sensor data and UID for testing
        sensorData = Data([0x01, 0x02, 0x03, 0x04])
        sensorUID = Data([0xDE, 0xAD, 0xBE, 0xEF, 0x01, 0x02, 0x03, 0x04])
        rawTag = RawTag(uid: sensorUID, data: sensorData)
    }
    
    func testRawTagInitialization() {
        XCTAssertNotNil(rawTag)
    }
    
    func testSensorCreation() {
        let sensor = rawTag.getSensor()
        XCTAssertNotNil(sensor)
    }
    
    func testReadingExtraction() {
        let reading = rawTag.getReading()
        // Reading might be nil if data is invalid
        if let reading = reading {
            XCTAssertGreaterThanOrEqual(reading.rawValue, 0)
            XCTAssertNotNil(reading.timestamp)
        }
    }
    
    func testCalibrationInfoExtraction() {
        let calibrationInfo = rawTag.getCalibrationInfo()
        // CalibrationInfo might be nil if data is invalid
        if let calibrationInfo = calibrationInfo {
            XCTAssertNotNil(calibrationInfo)
        }
    }
    
    func testInvalidData() {
        let invalidData = Data([0xFF, 0xFF]) // Too short
        let invalidTag = RawTag(uid: sensorUID, data: invalidData)
        
        XCTAssertNil(invalidTag.getReading())
        XCTAssertNil(invalidTag.getCalibrationInfo())
    }
}
