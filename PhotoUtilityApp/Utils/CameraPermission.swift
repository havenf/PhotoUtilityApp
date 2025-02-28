import UIKit
import AVFoundation

enum CameraPermission {
    enum CameraError: Error, LocalizedError {
        case unauthorized, unavailable, restricted
        
        var errorDescription: String? {
            switch self {
            case .unauthorized:
                return NSLocalizedString("Camera use not authorized", comment: "")
            case .unavailable:
                return NSLocalizedString("Camera is not available", comment: "")
            case .restricted:
                return NSLocalizedString("Camera access is restricted", comment: "")
            }
        }
        
        var recoverySuggestion: String? {
            switch self {
            case .unauthorized:
                return "Please enable camera access in Settings."
            case .unavailable:
                return "Use the photo library instead."
            case .restricted:
                return "Check device restrictions in Settings."
            }
        }
    }
    
    static func checkPermissions() -> CameraError? {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return .unavailable
        }
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            return nil
        case .restricted:
            return .restricted
        case .denied:
            return .unauthorized
        case .authorized:
            return nil
        @unknown default:
            return .unavailable
        }
    }
}
