import UIKit
import LibreSensor
import os.log

class ViewController: UIViewController {
    private let bluetoothManager = BluetoothManager.shared
    private let scanButton = UIButton(type: .system)
    private let resultLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let logger = Logger(subsystem: "com.fabioeloi.LibreSensorTestApp", category: "ViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Start Bluetooth scanning when view loads
        startBluetoothScanning()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Configure scan button
        scanButton.setTitle("Start Bluetooth Scan", for: .normal)
        scanButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        scanButton.backgroundColor = .systemBlue
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.layer.cornerRadius = 10
        scanButton.addTarget(self, action: #selector(scanButtonPressed), for: .touchUpInside)
        
        // Configure result label
        resultLabel.text = "Tap the button to start scanning for Freestyle Libre sensors via Bluetooth"
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 0
        resultLabel.font = .systemFont(ofSize: 16)
        
        // Configure activity indicator
        activityIndicator.hidesWhenStopped = true
        
        // Add subviews
        [scanButton, resultLabel, activityIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        // Set constraints
        NSLayoutConstraint.activate([
            scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            scanButton.widthAnchor.constraint(equalToConstant: 220),
            scanButton.heightAnchor.constraint(equalToConstant: 50),
            
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        ])
    }
    
    @objc private func scanButtonPressed() {
        startBluetoothScanning()
    }
    
    private func startBluetoothScanning() {
        // Show loading state
        activityIndicator.startAnimating()
        scanButton.isEnabled = false
        scanButton.setTitle("Scanning...", for: .normal)
        resultLabel.text = "Scanning for Freestyle Libre sensors via Bluetooth..."
        resultLabel.textColor = .label
        
        logger.info("Started Bluetooth scanning")
        
        // Start Bluetooth scanning
        bluetoothManager.startScanning { [weak self] result in
            DispatchQueue.main.async {
                self?.handleBluetoothScanResult(result)
            }
        }
    }
    
    private func handleBluetoothScanResult(_ result: Result<BluetoothReading, Error>) {
        // Reset UI
        activityIndicator.stopAnimating()
        scanButton.isEnabled = true
        scanButton.setTitle("Start Bluetooth Scan", for: .normal)
        
        switch result {
        case .success(let reading):
            logger.info("Received Bluetooth reading: \(reading)")
            showSuccess(reading: reading)
        case .failure(let error):
            logger.error("Bluetooth scan error: \(error.localizedDescription)")
            showError(error: error)
        }
    }
    
    private func showSuccess(reading: BluetoothReading) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        
        let message = """
        Reading received!
        
        Time: \(formatter.string(from: reading.timestamp))
        Glucose: \(reading.glucoseValue) mg/dL
        Trend: \(reading.trendArrow.rawValue)
        Sensor: \(reading.sensorSerialNumber)
        """
        
        resultLabel.text = message
        resultLabel.textColor = .systemGreen
    }
    
    private func showError(error: Error) {
        let errorMessage: String
        let errorColor: UIColor
        
        if let bluetoothError = error as? BluetoothError {
            switch bluetoothError {
            case .notReady:
                errorMessage = "Bluetooth is not ready. Please make sure Bluetooth is enabled in Settings."
            case .poweredOff:
                errorMessage = "Bluetooth is turned off. Please enable Bluetooth in Settings."
            case .unauthorized:
                errorMessage = "Bluetooth permission denied. Please allow Bluetooth access in Settings."
            case .unsupported:
                errorMessage = "Bluetooth is not supported on this device."
            case .unknown:
                errorMessage = "Unknown Bluetooth error occurred."
            }
            errorColor = .systemOrange
        } else {
            errorMessage = "Error: \(error.localizedDescription)"
            errorColor = .systemRed
        }
        
        resultLabel.text = errorMessage
        resultLabel.textColor = errorColor
    }
}
