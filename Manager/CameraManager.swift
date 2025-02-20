////
////  CameraManager.swift
////  VisionKitDemo
////
////  Created by Itsuki on 2024/07/26.
////
//
//
//import SwiftUI
//import AVFoundation
//
//@available(iOS 18.0, *)
//class CameraManager: NSObject {
//    
//    private let captureSession = AVCaptureSession()
//    
//    private var isCaptureSessionConfigured = false
//    private var deviceInput: AVCaptureDeviceInput?
//    
//    // for preview
//    private let videoOutput = AVCaptureVideoDataOutput()
//
//
//    // for preview device output
//    var isPreviewPaused = false
//
//    private var addToPreviewStream: ((CVPixelBuffer) -> Void)?
//    
//    lazy var previewStream: AsyncStream<CVPixelBuffer> = {
//        AsyncStream { continuation in
//            addToPreviewStream = { ciImage in
//                if !self.isPreviewPaused {
//                    continuation.yield(ciImage)
//                }
//            }
//        }
//    }()
//    
//    
//    override init() {
//        super.init()
//        setupCamera()
//    }
//    
//    private func setupCamera() {
//        captureSession.sessionPreset = .medium
//        
//        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
//              let input = try? AVCaptureDeviceInput(device: captureDevice) else {
//            print("Failed to access camera")
//            return
//        }
//        
//        if captureSession.canAddInput(input) {
//            captureSession.addInput(input)
//        }
//        
//        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//        videoOutput.alwaysDiscardsLateVideoFrames = true
//        
//        if captureSession.canAddOutput(videoOutput) {
//            captureSession.addOutput(videoOutput)
//        }
//    }
//    
//    // MARK: - Public Methods
//    func startLivePrediction() {
//        if !captureSession.isRunning {
//            captureSession.startRunning()
//        }
//    }
//    
//    func stopLivePrediction() {
//        if captureSession.isRunning {
//            captureSession.stopRunning()
//        }
//    }
//    
//    private func checkAuthorization() async -> Bool {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .authorized:
//            print("Camera access authorized.")
//            return true
//        case .notDetermined:
//            print("Camera access not determined.")
//            let status = await AVCaptureDevice.requestAccess(for: .video)
//            return status
//        case .denied:
//            print("Camera access denied.")
//            return false
//        case .restricted:
//            print("Camera library access restricted.")
//            return false
//        default:
//            return false
//        }
//    }
//
//}
//
//@available(iOS 18.0, *)
//extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
//    
//    nonisolated func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard let pixelBuffer = sampleBuffer.imageBuffer else { return }
//        addToPreviewStream?(pixelBuffer)
//    }
//    
//}
