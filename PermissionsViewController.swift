//
//  PermissionsViewController.swift
//  AV Foundation
//
//  Created by Christian Leovido on 14/12/2020.
//  Copyright © 2020 Pranjal Satija. All rights reserved.
//

import UIKit
import Photos

class PermissionsViewController: UIViewController {

    let allowNotificationsButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.addTarget(self, action: #selector(presentPermissions), for: .touchUpInside)
        button.setTitle("Allow notifications", for: .normal)
        button.backgroundColor = .blue

        return button
    }()

    let cancelButton: UIButton = {
        let cancelButton = UIButton.init(type: .system)
        cancelButton.addTarget(self, action: #selector(customDismiss), for: .touchUpInside)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = .red

        return cancelButton
    }()

    lazy var newView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .equalSpacing
        sv.backgroundColor = .green

        sv.translatesAutoresizingMaskIntoConstraints = false

        return sv
    }()

    @objc func customDismiss() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {

//        checkPermissions()
        checkPhotosPermissions()

        newView.addArrangedSubview(allowNotificationsButton)
        newView.addArrangedSubview(cancelButton)
        view.addSubview(newView)

        let constraints = [
            newView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)

        view.backgroundColor = .purple

    }

}

extension PermissionsViewController {
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case.authorized:
                return
            case .notDetermined:
                presentPermissions()
                break
            case .denied:
                presentPermissionsSettings()
                break
            case .restricted:
                break
        }
    }

    @objc func presentPermissionsSettings() {

        let alertController = UIAlertController(title: "Camera permission", message: "Please allow access for the camera in Settings in order for the camera to work", preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }

    }

    @objc func presentPermissions() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {

            } else {

            }
        }

    }
}

extension PermissionsViewController {

    // MARK: Photos permissions
    func checkPhotosPermissions() {

        let photos = PHPhotoLibrary.authorizationStatus()

        switch photos {
            case.authorized:
                return
            case .notDetermined:
                presentPhotoPermissions()
                break
            case .denied:
                presentPhotoPermissionsSettings()
                break
            case .restricted:
                break
            case .limited:
                break
        }
    }

    @objc func presentPhotoPermissionsSettings() {

        let alertController = UIAlertController(title: "Photo permission", message: "Please allow access for the camera in Settings in order for the camera to work", preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }

    }

    @objc func presentPhotoPermissions() {
        PHPhotoLibrary.requestAuthorization({ status in
            if status == .authorized{

            } else {
                self.presentPhotoPermissionsSettings()
            }
        })
    }
}
