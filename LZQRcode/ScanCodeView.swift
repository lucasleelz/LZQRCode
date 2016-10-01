//
//  ScanCodeView.swift
//  LZQRcode
//
//  Created by lucas on 2016/9/29.
//  Copyright © 2016年 三只小猪. All rights reserved.
//

import UIKit
import AVFoundation

open class ScanCodeView: UIView {
    
    weak public var delegate: ScanCodeViewDelegate?
    
    lazy var device: AVCaptureDevice = {
        return AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    }()
    
    lazy var input: AVCaptureInput = {
        return try! AVCaptureDeviceInput(device: self.device)
    }()
    
    lazy var output: AVCaptureMetadataOutput = {
        let result = AVCaptureMetadataOutput()
        result.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        return result
    }()
    
    lazy var session: AVCaptureSession = {
        let result = AVCaptureSession()
        result.sessionPreset = AVCaptureSessionPresetHigh
        if result.canAddInput(self.input) {
            result.addInput(self.input)
        }
        if result.canAddOutput(self.output) {
            result.addOutput(self.output)
        }
        return result
    }()
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    var aaa: Int?
    
    private func setupViews() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
        
        if let previewLayer = self.previewLayer {
            self.layer.insertSublayer(previewLayer, at: 0)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.previewLayer?.frame = self.bounds
    }
    
    public func startScanCode() {
        self.output.metadataObjectTypes = [AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode]
        self.session.startRunning()
    }
    
    public func stopScanCode() {
        self.session.stopRunning()
    }
}

// MARK: - ScanCodeViewDelegate

public protocol ScanCodeViewDelegate: class {
    
    func scanCodeView(scanCodeView: ScanCodeView, didScanCodeResult codeResult: String)
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension ScanCodeView: AVCaptureMetadataOutputObjectsDelegate {
    
    public func captureOutput(_ captureOutput: AVCaptureOutput!,
                       didOutputMetadataObjects metadataObjects: [Any]!,
                       from connection: AVCaptureConnection!) {
        
        guard metadataObjects.count > 0 else {
            return
        }
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        self.delegate?.scanCodeView(scanCodeView: self, didScanCodeResult: metadataObject.stringValue)
    }
}
