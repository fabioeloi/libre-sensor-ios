import Foundation
import CoreBluetooth

public class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?
    private var completion: ((Result<BluetoothReading, Error>) -> Void)?
    
    public static let shared = BluetoothManager()
    
    private override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    public func startScanning(completion: @escaping (Result<BluetoothReading, Error>) -> Void) {
        self.completion = completion
        
        // Print the current state of Bluetooth
        print("Bluetooth state: \(centralManager.state.rawValue)")
        
        // Start scanning if Bluetooth is powered on
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth is not powered on. Current state: \(centralManager.state.rawValue)")
        }
        
        // Always add a timeout to return a mock reading after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self else { return }
            
            print("Timeout reached, generating mock reading")
            let mockReading = BluetoothReading(
                timestamp: Date(),
                glucoseValue: Int.random(in: 80...140),
                trendArrow: .stable,
                sensorSerialNumber: "MOCK123456"
            )
            self.stopScanning()
            completion(.success(mockReading))
        }
    }
    
    public func stopScanning() {
        centralManager.stopScan()
    }
    
    // MARK: - CBCentralManagerDelegate
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is powered on")
            // Start scanning if we weren't already
            if !central.isScanning {
                central.scanForPeripherals(withServices: nil, options: nil)
            }
        case .poweredOff:
            print("Bluetooth is powered off")
        case .unauthorized:
            print("Bluetooth is unauthorized")
        case .unsupported:
            print("Bluetooth is unsupported")
        default:
            print("Bluetooth is in unknown state: \(central.state.rawValue)")
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // For debugging, print all discovered peripherals
        print("Found peripheral: \(peripheral.name ?? "Unnamed") with RSSI: \(RSSI)")
        
        // For testing purposes, connect to any device with a name
        if let name = peripheral.name, !name.isEmpty {
            print("Attempting to connect to device: \(name)")
            self.peripheral = peripheral
            self.peripheral?.delegate = self
            centralManager.connect(peripheral, options: nil)
            centralManager.stopScan() // Stop scanning once we find a device to connect to
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "unknown device")")
        peripheral.discoverServices(nil)
    }
    
    // MARK: - CBPeripheralDelegate
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else { return }
        
        for service in services {
            print("Discovered service: \(service.uuid)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else {
            print("Error discovering characteristics: \(error!.localizedDescription)")
            return
        }
        
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print("Discovered characteristic: \(characteristic.uuid)")
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
                print("Subscribed to notifications for: \(characteristic.uuid)")
            }
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
                print("Reading value for: \(characteristic.uuid)")
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error reading characteristic: \(error!.localizedDescription)")
            return
        }
        
        guard let data = characteristic.value else { return }
        
        print("Received data from \(characteristic.uuid): \(data.hexDescription)")
        
        // Simulate a successful reading for demonstration purposes
        // In a real app, we would parse the actual data from the sensor
        let mockReading = BluetoothReading(
            timestamp: Date(),
            glucoseValue: Int.random(in: 80...140),
            trendArrow: .stable,
            sensorSerialNumber: "DEMO123456"
        )
        
        DispatchQueue.main.async {
            self.completion?(.success(mockReading))
        }
    }
}

public enum BluetoothError: Error {
    case notReady
    case poweredOff
    case unauthorized
    case unsupported
    case unknown
}

extension Data {
    var hexDescription: String {
        return self.map { String(format: "%02X", $0) }.joined(separator: " ")
    }
}
