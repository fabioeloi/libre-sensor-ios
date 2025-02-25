import UIKit
import LibreSensor
import os.log

class ViewController: UIViewController {
    private let nfcManager = NFCManager()
    private let scanButton = UIButton(type: .system)
    private let resultLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let logger = Logger(subsystem: "com.fabioeloi.LibreSensor", category: "SensorScanning")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Configure scan button
        scanButton.setTitle("Scan Sensor", for: .normal)
        scanButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        scanButton.backgroundColor = .systemBlue
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.layer.cornerRadius = 10
        scanButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
        
        // Configure result label
        resultLabel.numberOfLines = 0
        resultLabel.textAlignment = .center
        resultLabel.font = .systemFont(ofSize: 16)
        
        // Configure activity indicator
        activityIndicator.hidesWhenStopped = true
        
        // Add views to hierarchy
        view.addSubview(scanButton)
        view.addSubview(resultLabel)
        view.addSubview(activityIndicator)
        
        // Layout constraints
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            resultLabel.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: scanButton.topAnchor, constant: -20)
        ])
    }
    
    @objc private func scanButtonTapped() {
        startScanning()
    }
    
    private func startScanning() {
        // Show scanning state
        activityIndicator.startAnimating()
        scanButton.isEnabled = false
        resultLabel.text = "Scanning for sensor..."
        resultLabel.textColor = .label
        
        logger.info("Starting sensor scan")
        
        nfcManager.startScanning { [weak self] result in
            DispatchQueue.main.async {
                self?.handleScanResult(result)
            }
        }
    }
    
    private func handleScanResult(_ result: Result<RawTag, Error>) {
        // Reset UI state
        activityIndicator.stopAnimating()
        scanButton.isEnabled = true
        
        switch result {
        case .success(let rawTag):
            handleSuccessfulScan(rawTag)
        case .failure(let error):
            handleScanError(error)
        }
    }
    
    private func handleSuccessfulScan(_ rawTag: RawTag) {
        logger.info("Successfully scanned sensor")
        
        // Get sensor information
        let sensor = rawTag.getSensor()
        let serialNumber = sensor.getSerialNumber()
        let sensorState = sensor.getState()
        
        if let reading = rawTag.getReading() {
            let glucoseValue = reading.glucose.value
            let glucoseUnit = reading.glucose.unit
            let timestamp = reading.timestamp
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            
            let resultText = """
                Glucose: \(glucoseValue) \(glucoseUnit)
                Time: \(dateFormatter.string(from: timestamp))
                Serial: \(serialNumber)
                State: \(sensorState)
                """
            
            resultLabel.text = resultText
            resultLabel.textColor = .systemGreen
            logger.info("Glucose reading: \(glucoseValue) \(glucoseUnit)")
        } else {
            resultLabel.text = "No reading available"
            resultLabel.textColor = .systemOrange
            logger.warning("No reading available from sensor")
        }
    }
    
    private func handleScanError(_ error: Error) {
        logger.error("Scan error: \(error.localizedDescription)")
        
        let errorMessage: String
        let errorColor: UIColor
        
        switch error {
        case NFCError.notAvailable:
            errorMessage = "NFC is not available on this device"
            errorColor = .systemRed
        case NFCError.notEnabled:
            errorMessage = "NFC is not enabled. Please enable it in Settings"
            errorColor = .systemOrange
        case NFCError.noTagFound:
            errorMessage = "No sensor found. Please make sure the sensor is placed correctly near the top of your iPhone"
            errorColor = .systemOrange
        case NFCError.invalidData:
            errorMessage = "Invalid sensor data. Please try scanning again"
            errorColor = .systemRed
        default:
            errorMessage = "Error: \(error.localizedDescription)"
            errorColor = .systemRed
        }
        
        resultLabel.text = errorMessage
        resultLabel.textColor = errorColor
    }
}
