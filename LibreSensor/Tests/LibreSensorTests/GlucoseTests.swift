import XCTest
@testable import LibreSensor

final class GlucoseTests: XCTestCase {
    func testMgdLToMmolL() {
        let glucose = Glucose(value: 180.0, unit: .mgdL)
        XCTAssertEqual(glucose.getValue(in: .mmolL), 10.0, accuracy: 0.1)
    }
    
    func testMmolLToMgdL() {
        let glucose = Glucose(value: 10.0, unit: .mmolL)
        XCTAssertEqual(glucose.getValue(in: .mgdL), 180.0, accuracy: 0.1)
    }
    
    func testSameUnitConversion() {
        let glucoseMgdL = Glucose(value: 180.0, unit: .mgdL)
        XCTAssertEqual(glucoseMgdL.getValue(in: .mgdL), 180.0)
        
        let glucoseMmolL = Glucose(value: 10.0, unit: .mmolL)
        XCTAssertEqual(glucoseMmolL.getValue(in: .mmolL), 10.0)
    }
    
    func testEdgeCases() {
        let zeroGlucose = Glucose(value: 0.0, unit: .mgdL)
        XCTAssertEqual(zeroGlucose.getValue(in: .mmolL), 0.0)
        
        let highGlucose = Glucose(value: 600.0, unit: .mgdL)
        XCTAssertEqual(highGlucose.getValue(in: .mmolL), 33.33, accuracy: 0.01)
    }
}
