///*
//See the LICENSE.txt file for this sample’s licensing information.
//
//Abstract:
//Contains the view controller for the Breakfast Finder.
//*/
//
import AVFoundation
import Vision

class VideoViewController: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public let session = AVCaptureSession()
    public var cameraSetup = false
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // to be implemented in the subclass
    }
    
    override init() {
        super.init()
        setupAVCapture()
    }
    
    
    func setupAVCapture() {
        session.sessionPreset = .medium
                
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: captureDevice) else {
            print("Failed to access camera")
            return
        }
        cameraSetup = true
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
        }
    }
    
    func startCaptureSession() {
        if !session.isRunning {
            session.startRunning()
           }
    }
    
    // Clean up capture setup
    func teardownAVCapture() {
        if session.isRunning {
            session.stopRunning()
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput, didDrop didDropSampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // print("frame dropped")
    }
    
}


