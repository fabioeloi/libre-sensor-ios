import XCTest
@testable import LibreSensor

final class SensorTests: XCTestCase {
    var sensorData: Data!
    var sensorUID: Data!
    
    override func setUp() {
        super.setUp()
        // Sample sensor data and UID for testing
        sensorData = Data([0x01, 0x02, 0x03, 0x04])
        sensorUID = Data([0xDE, 0xAD, 0xBE, 0xEF, 0x01, 0x02, 0x03, 0x04])
    }
    
    func testSensorInitialization() {
        let sensor = Sensor(uid: sensorUID, info: sensorData)
        XCTAssertNotNil(sensor)
        XCTAssertNotEqual(sensor.getSerialNumber(), "")
    }
    
    func testSensorRegions() {
        let europeanSensor = Sensor(uid: sensorUID, info: sensorData, region: .european)
        let usaSensor = Sensor(uid: sensorUID, info: sensorData, region: .usa)
        
        XCTAssertNotEqual(europeanSensor.getSerialNumber(), usaSensor.getSerialNumber())
    }
    
    func testSensorStates() {
        let sensor = Sensor(uid: sensorUID, info: sensorData)
        
        // Test all possible sensor states
        let states: [SensorState] = [
            .unknown,
            .notActivated,
            .warmingUp,
            .active,
            .expired,
            .failure,
            .terminated
        ]
        
        for state in states {
            XCTAssertEqual(state.rawValue, states.firstIndex(of: state))
        }
    }
    
    func testSensorAge() {
        let sensor = Sensor(uid: sensorUID, info: sensorData)
        XCTAssertGreaterThanOrEqual(sensor.getAge(), 0)
    }
}
