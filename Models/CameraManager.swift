//
//  CameraManager.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/21.
//

@preconcurrency import AVFoundation
import SwiftUI

@available(iOS 18.0, *)
class CameraManager: NSObject, ObservableObject{

    public let captureSession = AVCaptureSession()

    private var isCaptureSessionConfigured = false
    private var deviceInput: AVCaptureDeviceInput?

    // for preview
    private var videoOutput: AVCaptureVideoDataOutput?
    private var sessionQueue: DispatchQueue!

    @Published var isCameraReady = false
    private var addToPreviewStream: ((CVPixelBuffer) -> Void)?

    lazy var previewStream: AsyncStream<CVPixelBuffer> = {
        AsyncStream { continuation in
            addToPreviewStream = { buffer in
                continuation.yield(buffer)
            }
        }
    }()

    override init() {
        super.init()
        captureSession.sessionPreset = .high
        sessionQueue = DispatchQueue(label: "session queue")
    }

    func start() async {
        let authorized = await checkAuthorization()
        guard authorized else {
            print("Camera access was not authorized.")
            return
        }

        if isCaptureSessionConfigured {
            if !captureSession.isRunning {
                sessionQueue.async { [self] in
                    DispatchQueue.main.async {
                       self.isCameraReady = true
                   }
                    self.captureSession.startRunning()
                }
            }
            return
        }

        sessionQueue.async { [self] in
            self.configureCaptureSession { success in
                guard success else { return }
                DispatchQueue.main.async {
                   self.isCameraReady = true
               }
                self.captureSession.startRunning()
            }
        }
    }

    func stop() {
        guard isCaptureSessionConfigured else { return }

        if captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.stopRunning()
            }
        }
    }

    private func configureCaptureSession(
        completionHandler: (_ success: Bool) -> Void
    ) {

        var success = false

        self.captureSession.beginConfiguration()

        defer {
            self.captureSession.commitConfiguration()
            completionHandler(success)
        }

        guard
            let captureDevice = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera], mediaType: .video,
                position: .back
            ).devices.first,
            let deviceInput = try? AVCaptureDeviceInput(device: captureDevice)
        else {
            print("Failed to obtain video input.")
            return
        }

        captureSession.sessionPreset = AVCaptureSession.Preset.vga640x480

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: Int(
                kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
        ]
        videoOutput.setSampleBufferDelegate(
            self, queue: DispatchQueue(label: "VideoDataOutputQueue"))
        if let videoOutputConnection = videoOutput.connection(with: .video) {
            if videoOutputConnection.isVideoMirroringSupported {
                videoOutputConnection.isVideoMirrored = false
            }
        }

        guard captureSession.canAddOutput(videoOutput) else {
            print("Unable to add video output to capture session.")
            return
        }

        captureSession.addInput(deviceInput)
        captureSession.addOutput(videoOutput)

        self.deviceInput = deviceInput
        self.videoOutput = videoOutput

        isCaptureSessionConfigured = true

        success = true
    }

    private func checkAuthorization() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            print("Camera access authorized.")
            return true
        case .notDetermined:
            print("Camera access not determined.")
            sessionQueue.suspend()
            let status = await AVCaptureDevice.requestAccess(for: .video)
            sessionQueue.resume()
            return status
        case .denied:
            print("Camera access denied.")
            return false
        case .restricted:
            print("Camera library access restricted.")
            return false
        default:
            return false
        }
    }

}

@available(iOS 18.0, *)
extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(
        _ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        else {
            return
        }

        guard let bgraPixelBuffer = convertToBGRA(pixelBuffer) else {
            print("Failed to convert YUV to BGRA")
            return
        }

        guard
            let resizedPixelBuffer = resizePixelBuffer(
                bgraPixelBuffer, width: 224, height: 224)
        else {
            print("Failed to resize image to 224x224")
            return
        }

        addToPreviewStream?(resizedPixelBuffer)

    }

    func resizePixelBuffer(
        _ pixelBuffer: CVPixelBuffer, width: Int, height: Int
    ) -> CVPixelBuffer? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()

        let resizedImage = ciImage.transformed(
            by: CGAffineTransform(
                scaleX: CGFloat(width)
                    / CGFloat(CVPixelBufferGetWidth(pixelBuffer)),
                y: CGFloat(height)
                    / CGFloat(CVPixelBufferGetHeight(pixelBuffer))))

        var resizedPixelBuffer: CVPixelBuffer?
        let attributes =
            [
                kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA,
                kCVPixelBufferWidthKey: width,
                kCVPixelBufferHeightKey: height,
            ] as CFDictionary

        CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32BGRA,
            attributes,
            &resizedPixelBuffer
        )

        if let resizedPixelBuffer = resizedPixelBuffer {
            context.render(resizedImage, to: resizedPixelBuffer)
            return resizedPixelBuffer
        }

        return nil
    }

    func convertToBGRA(_ pixelBuffer: CVPixelBuffer) -> CVPixelBuffer? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()

        var bgraPixelBuffer: CVPixelBuffer?
        let attributes =
            [
                kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA,
                kCVPixelBufferWidthKey: CVPixelBufferGetWidth(pixelBuffer),
                kCVPixelBufferHeightKey: CVPixelBufferGetHeight(pixelBuffer),
            ] as CFDictionary

        CVPixelBufferCreate(
            kCFAllocatorDefault,
            CVPixelBufferGetWidth(pixelBuffer),
            CVPixelBufferGetHeight(pixelBuffer),
            kCVPixelFormatType_32BGRA,
            attributes,
            &bgraPixelBuffer
        )

        if let bgraPixelBuffer = bgraPixelBuffer {
            context.render(ciImage, to: bgraPixelBuffer)
            return bgraPixelBuffer
        }

        return nil
    }

}
