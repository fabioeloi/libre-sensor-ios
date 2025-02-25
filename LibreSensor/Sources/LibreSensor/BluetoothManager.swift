import Foundation
import CoreBluetooth

public class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?
    private var completion: ((Result<Reading, Error>) -> Void)?
    
    public static let shared = BluetoothManager()
    
    private override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    public func startScanning(completion: @escaping (Result<Reading, Error>) -> Void) {
        self.completion = completion
        
        guard centralManager.state == .poweredOn else {
            completion(.failure(BluetoothError.notReady))
            return
        }
        
        // FreeStyle Libre 2 Plus uses specific service UUID
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    public func stopScanning() {
        centralManager.stopScan()
    }
    
    // MARK: - CBCentralManagerDelegate
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is powered on")
        case .poweredOff:
            completion?(.failure(BluetoothError.poweredOff))
        case .unauthorized:
            completion?(.failure(BluetoothError.unauthorized))
        case .unsupported:
            completion?(.failure(BluetoothError.unsupported))
        default:
            completion?(.failure(BluetoothError.unknown))
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // Check if this is a FreeStyle Libre device
        guard let name = peripheral.name, name.contains("Libre") else { return }
        
        self.peripheral = peripheral
        self.peripheral?.delegate = self
        centralManager.connect(peripheral, options: nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "unknown device")")
        peripheral.discoverServices(nil)
    }
    
    // MARK: - CBPeripheralDelegate
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let data = characteristic.value else { return }
        
        // Process the received data
        // Note: The actual data format will depend on the FreeStyle Libre 2 Plus protocol
        print("Received data: \(data)")
    }
}

public enum BluetoothError: Error {
    case notReady
    case poweredOff
    case unauthorized
    case unsupported
    case unknown
}
