import UIKit
import LibreSensor

class ViewController: UIViewController {
    private let nfcManager = NFCManager()
    private let scanButton = UIButton(type: .system)
    private let resultLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Configure scan button
        scanButton.setTitle("Scan Sensor", for: .normal)
        scanButton.addTarget(self, action: #selector(scanButtonTapped), for: .touchUpInside)
        
        // Configure result label
        resultLabel.numberOfLines = 0
        resultLabel.textAlignment = .center
        
        // Add views to hierarchy
        view.addSubview(scanButton)
        view.addSubview(resultLabel)
        
        // Layout constraints
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            resultLabel.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 20),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func scanButtonTapped() {
        nfcManager.startScanning { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let rawTag):
                    if let reading = rawTag.getReading() {
                        self?.resultLabel.text = "Glucose: \(reading.glucose.value) \(reading.glucose.unit)"
                    } else {
                        self?.resultLabel.text = "No reading available"
                    }
                case .failure(let error):
                    self?.resultLabel.text = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}
