# LibreSensor iOS

This is an iOS library and test application for interacting with Freestyle Libre glucose sensors. The project currently focuses on Bluetooth connectivity with Freestyle Libre 2 sensors.

## Current State

The project has been refactored to focus on Bluetooth functionality instead of NFC. Key features include:

- Mock readings generation for testing UI/UX
- Bluetooth scanning capability
- Basic sensor data model
- Test application demonstrating the functionality

### Bluetooth Implementation Notes

After investigation, we found that Freestyle Libre 2 sensors:
1. Use a proprietary Bluetooth protocol with encryption
2. Can only pair with one device at a time (either LibreLink app or Reader)
3. Require initial NFC activation before Bluetooth communication
4. Do not provide an official API/SDK for third-party integration

Due to these limitations, the current implementation provides mock readings for testing purposes.

## Project Structure

```
LibreSensor/
├── Sources/
│   └── LibreSensor/
│       ├── BluetoothManager.swift    // BLE communication
│       ├── BluetoothReading.swift    // Reading data model
│       └── NFCManager.swift          // Legacy NFC code (commented out)
└── SensorTestApp/                    // iOS test application
    ├── SensorTestApp/
    │   ├── ViewController.swift      // Main UI
    │   ├── Info.plist               // App configuration
    │   └── LaunchScreen.storyboard  // Launch screen
    └── project.yml                  // Project configuration
```

## Requirements

- iOS 13.0+
- Xcode 14.0+
- Swift 5.5+
- iPhone with Bluetooth capability

## Test Application Usage

1. Install and launch the app
2. Grant Bluetooth permissions when prompted
3. Tap "Start Bluetooth Scan"
4. After 5 seconds, a mock reading will be displayed
   - Mock readings include random glucose values (80-140 mg/dL)
   - Stable trend arrow
   - Mock sensor serial number

## Future Development Options

1. **Official Integration**
   - Explore partnership opportunities with Abbott
   - Wait for potential official SDK release

2. **NFC-First Approach**
   - Implement NFC activation
   - Research Bluetooth protocol
   - Note: This would require significant reverse engineering

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This software is not affiliated with or endorsed by Abbott Laboratories or any of its subsidiaries. Freestyle Libre is a trademark of Abbott Laboratories.