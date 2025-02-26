import Foundation

public struct BluetoothReading: CustomStringConvertible {
    public let timestamp: Date
    public let glucoseValue: Int
    public let trendArrow: TrendArrow
    public let sensorSerialNumber: String
    
    public init(timestamp: Date, glucoseValue: Int, trendArrow: TrendArrow, sensorSerialNumber: String) {
        self.timestamp = timestamp
        self.glucoseValue = glucoseValue
        self.trendArrow = trendArrow
        self.sensorSerialNumber = sensorSerialNumber
    }
    
    public var description: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return "BluetoothReading(time: \(formatter.string(from: timestamp)), glucose: \(glucoseValue) mg/dL, trend: \(trendArrow.rawValue), sensor: \(sensorSerialNumber))"
    }
}

public enum TrendArrow: String {
    case risingQuickly = "↑↑"
    case rising = "↑"
    case stable = "→"
    case falling = "↓"
    case fallingQuickly = "↓↓"
    case unknown = "?"
}
