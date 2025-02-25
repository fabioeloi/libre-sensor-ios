import Foundation

public enum GlucoseUnit {
    case mgdL
    case mmolL
    
    func convert(_ value: Double, to unit: GlucoseUnit) -> Double {
        switch (self, unit) {
        case (.mgdL, .mmolL):
            return value / 18.0
        case (.mmolL, .mgdL):
            return value * 18.0
        default:
            return value
        }
    }
}

public struct Glucose {
    public let value: Double
    public let unit: GlucoseUnit
    
    public init(value: Double, unit: GlucoseUnit) {
        self.value = value
        self.unit = unit
    }
    
    public func getValue(in unit: GlucoseUnit) -> Double {
        return self.unit.convert(value, to: unit)
    }
}
