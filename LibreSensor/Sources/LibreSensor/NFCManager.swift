import Foundation

#if CORE_NFC
// import CoreNFC

// @available(iOS 13.0, *)
public class NFCManager: NSObject {
    // private var session: NFCTagReaderSession?
    // private var completionHandler: ((Result<RawTag, Error>) -> Void)?
    
    public override init() {
        super.init()
    }
    
    // public func startScanning(completion: @escaping (Result<RawTag, Error>) -> Void) {
    //     guard NFCTagReaderSession.readingAvailable else {
    //         completion(.failure(NFCError.notAvailable))
    //         return
    //     }
        
    //     self.completionHandler = completion
    //     session = NFCTagReaderSession(pollingOption: .iso15693, delegate: self)
    //     session?.alertMessage = "Hold your iPhone near the Freestyle Libre sensor"
    //     session?.begin()
    // }
    
    // public func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
    //     // Session became active
    // }
    
    // public func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
    //     // Handle error
    //     completionHandler?(.failure(error))
    //     self.session = nil
    // }
    
    // public func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
    //     guard let firstTag = tags.first,
    //           case let .iso15693(tag) = firstTag else {
    //         session.invalidate(errorMessage: "Unsupported tag type")
    //         return
    //     }
        
    //     session.connect(to: firstTag) { error in
    //         if let error = error {
    //             session.invalidate(errorMessage: error.localizedDescription)
    //             return
    //         }
            
    //         // Read sensor data
    //         // self.readSensorData(tag: tag, session: session)
    //     }
    // }
    
    // private func readSensorData(tag: NFCISO15693Tag, session: NFCTagReaderSession) {
    //     // Implementation of sensor data reading
    //     // This will use the appropriate commands to read the Freestyle Libre sensor
    // }
}

#else

public class NFCManager {
    public init() {}
    
    // public func startScanning(completion: @escaping (Result<RawTag, Error>) -> Void) {
    //     completion(.failure(NFCError.notAvailable))
    // }
}

#endif

public enum NFCError: Error {
    case notAvailable
    case readError
}
