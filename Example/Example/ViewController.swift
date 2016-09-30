//
//  ViewController.swift
//  Example
//
//  Created by lucas on 2016/9/30.
//  Copyright © 2016年 三只小猪. All rights reserved.
//

import UIKit
import LZQRcode
import AVFoundation

class ViewController: UIViewController {
    
    lazy var scanCode: ScanCodeView = {
        let result = ScanCodeView(frame: self.view.bounds)
        result.delegate = self
        return result
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.scanCode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let authorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { (granted) in
                if granted {
                    self.scanCode.startScanCode()
                }
            }
            break;
        case .restricted:
            print("受限")
            break;
        case .denied:
            print("拒绝")
            break;
        case .authorized:
            self.scanCode.startScanCode()
            break
        }
        
    }
}

extension ViewController: ScanCodeViewDelegate {
    
    func scanCodeView(scanCodeView: ScanCodeView, didScanCodeResult codeResult: String) {
        print("扫码结果：\(codeResult)")
    }
}

