import Foundation

public struct Reading {
    public let rawValue: Int
    public let timestamp: Date
    
    public init(rawValue: Int, timestamp: Date) {
        self.rawValue = rawValue
        self.timestamp = timestamp
    }
    
    public func getGlucose(calibrationInfo: CalibrationInfo) -> Glucose {
        // Implementation of glucose calculation
        // This will mirror the Android implementation
        return Glucose(value: Double(rawValue), unit: .mgdL)
    }
}
