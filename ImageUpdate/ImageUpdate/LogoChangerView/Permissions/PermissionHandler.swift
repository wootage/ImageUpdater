//
//  PermissionHandler.swift
//  LogoChanger
//
//  Created by Dimitar Dimitrov on 26/10/2023.
//

import Foundation
import Photos

protocol PermissionHandlerProtocol {
    func checkPermissionStatus(_ permission: Permission, result: @escaping PermissionResult)
}

enum Permission {
    case camera
}

typealias PermissionResult = (Bool) -> Void

class PermissionHandler: NSObject, PermissionHandlerProtocol {
    
    static let handler = PermissionHandler()
    private override init() {}
    
    func checkPermissionStatus(_ permission: Permission, result: @escaping PermissionResult) {

        switch permission {
        case .camera:
            checkCameraPermission(result: result)
        }
    }
    
    private func checkCameraPermission(result: @escaping PermissionResult) {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authorizationStatus != .notDetermined {
            result(authorizationStatus == .authorized)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                DispatchQueue.main.async {
                    result(authorized)
                }
            }
        }
    }
}
