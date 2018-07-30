//
//  CameraVC.swift
//  Spectacle
//
//  Created by Dan Lindsay on 2018-05-31.
//  Copyright © 2018 Dan Lindsay. All rights reserved.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {
    
    //MARK: - Class Properties
    let output = AVCapturePhotoOutput()
    let dismissBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "right_arrow_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(backBtnPressed), for: .touchUpInside)
        return button
    }()
    let capturePhotoBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "capture_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        return button
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Class Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupButtonsOnView()
    }
    
    //MARK: - Custom Methods
    @objc func capturePhoto() {
        print("Capturing photo")
        
        let settings = AVCapturePhotoSettings()
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        output.capturePhoto(with: settings, delegate: self)
    }
    
    @objc func backBtnPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupButtonsOnView() {
        view.addSubview(capturePhotoBtn)
        capturePhotoBtn.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 30, paddingRight: 0, width: 100, height: 100)
        capturePhotoBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissBtn)
        dismissBtn.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
    }
    
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        //setup inputs
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            print("Could not capture photo:", error)
        }
        
        //setup outputs
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        //setup output preview
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
}

//MARK: - AVCapturePhotoCaptureDelegate
extension CameraVC: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("Failed to capture photo: \(error.debugDescription)")
            return
        }
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        let previewImage = UIImage(data: imageData)
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = previewImage
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
//        let previewImageView = UIImageView(image: previewImage)
//        view.addSubview(previewImageView)
//        previewImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        print("finish processing photo sample buffer")
    }
}








