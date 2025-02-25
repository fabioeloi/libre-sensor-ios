# LibreSensor iOS

This is an iOS library for reading and processing data from Freestyle Libre glucose sensors. It is a Swift port of the Android library [libre-sensor](https://github.com/galekseev/libre-sensor) by [galekseev](https://github.com/galekseev).

## Features

- Read data from Freestyle Libre sensors using NFC
- Parse sensor data and extract glucose readings
- Calculate glucose values using sensor calibration data
- Support for different sensor regions (European and US)
- Support for different glucose units (mg/dL and mmol/L)
- Cross-platform compatibility (iOS/macOS) with conditional compilation
- Comprehensive test suite

## Requirements

- iOS 13.0+ / macOS 10.15+
- Xcode 14.0+
- Swift 5.5+
- iPhone 7 or newer for NFC functionality
- Apple Developer account with NFC entitlements for real device testing

## Installation

### Swift Package Manager

Add the following dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/fabioeloi/libre-sensor-ios.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. File > Add Packages
2. Enter the repository URL
3. Choose the version you want to use

## Usage

### Basic Usage

1. Import the library:
```swift
import LibreSensor
```

2. Create an NFCManager instance:
```swift
let nfcManager = NFCManager()
```

3. Start scanning for sensors:
```swift
nfcManager.startScanning { result in
    switch result {
    case .success(let rawTag):
        if let reading = rawTag.getReading() {
            print("Glucose: \(reading.glucose.value) \(reading.glucose.unit)")
        }
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

### Advanced Usage

#### Working with Sensor Data
```swift
// Get sensor information
let sensor = rawTag.getSensor()
let serialNumber = sensor.getSerialNumber()
let sensorState = sensor.getState()
let sensorAge = sensor.getAge()

// Get calibration information
if let calibrationInfo = rawTag.getCalibrationInfo() {
    // Use calibration info for accurate readings
}

// Get detailed reading information
if let reading = rawTag.getReading() {
    let glucose = reading.glucose
    let timestamp = reading.timestamp
    
    // Convert units if needed
    let mgdL = glucose.getValue(in: .mgdL)
    let mmolL = glucose.getValue(in: .mmolL)
}
```

### Sample App

A sample application demonstrating the library usage is included in the `SensorTestApp` directory. It provides a basic interface for scanning sensors and displaying readings.

## Project Structure

```
LibreSensor/
├── Sources/
│   └── LibreSensor/
│       ├── NFCManager.swift    // NFC communication
│       ├── RawTag.swift        // Raw sensor data handling
│       ├── Sensor.swift        // Sensor state management
│       ├── Reading.swift       // Glucose reading processing
│       ├── Glucose.swift       // Glucose value handling
│       └── CalibrationInfo.swift // Sensor calibration
├── Tests/
│   └── LibreSensorTests/
│       └── ... // Unit tests for each component
└── SensorTestApp/ // Sample iOS application
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Testing

The project includes a comprehensive test suite. Run the tests using:

```bash
swift test
```

For iOS-specific features, use Xcode's test navigator or run:

```bash
xcodebuild test -scheme LibreSensor -destination 'platform=iOS Simulator,name=iPhone 14'
```

## Credits

This project is a Swift port of the [libre-sensor](https://github.com/galekseev/libre-sensor) Android library by [galekseev](https://github.com/galekseev). The original implementation and protocol reverse engineering were done by the original author.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This software is not affiliated with or endorsed by Abbott Laboratories or any of its subsidiaries. Freestyle Libre is a trademark of Abbott Laboratories.
