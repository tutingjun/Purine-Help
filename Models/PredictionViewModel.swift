////
////  TEst.swift
////  Purine Help
////
////  Created by 涂庭鋆 on 2025/2/20.
////
//
//// MARK: - PredictionViewModel.swift (ViewModel部分)
//import SwiftUI
//import AVFoundation
//import Vision
//import CoreML
//
//@MainActor
//class PredictionViewModel: NSObject, ObservableObject {
//    // 视频处理相关
//    private let captureSession = AVCaptureSession()
//    private var videoOutput = AVCaptureVideoDataOutput()
//    
//    // 模型相关
//    private var coreMLModel: VNCoreMLModel?
//    private var requests = [VNCoreMLRequest]()
//    
//    // 预测结果
//    @Published var predictionResult: String = ""
//    @Published var confidence: Double = 0
//    
//    override init() {
//        super.init()
//        setupCamera()
//        loadModel()
//    }
//    
//    // 初始化摄像头
//    private func setupCamera() {
//        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
//              let input = try? AVCaptureDeviceInput(device: device) else { return }
//        
//        if captureSession.canAddInput(input) {
//            captureSession.addInput(input)
//        }
//        
//        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
//        if captureSession.canAddOutput(videoOutput) {
//            captureSession.addOutput(videoOutput)
//        }
//        
//        captureSession.startRunning()
//    }
//    
//    // 加载CoreML模型（示例使用DeepLabV3）
//    private func loadModel() {
//           do {
//               let config = MLModelConfiguration()
//               let model = try Food101(configuration: config)
//               coreMLModel = try VNCoreMLModel(for: model.model)
//               setupVisionRequest()
//           } catch {
//               print("模型加载失败: \(error)")
//           }
//       }
//    
//    // 配置Vision请求
//    private func setupVisionRequest() {
//        guard let model = coreMLModel else { return }
//        
//        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
//            self?.processPredictions(for: request, error: error)
//        }
//        request.imageCropAndScaleOption = .scaleFill
//        requests = [request]
//    }
//    
//    // 处理预测结果
//    private func processPredictions(for request: VNRequest, error: Error?) {
//        guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else { return }
//        
//        DispatchQueue.main.async {
//            self.predictionResult = topResult.identifier
//            self.confidence = Double(topResult.confidence)
//        }
//    }
//}
//
//extension PredictionViewModel: AVCaptureVideoDataOutputSampleBufferDelegate {
//    nonisolated func captureOutput(_ output: AVCaptureOutput,
//                       didOutput sampleBuffer: CMSampleBuffer,
//                       from connection: AVCaptureConnection) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//            return
//        }
//        
//        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)
//        
//        do {
//            try requestHandler.perform(self.requests)
//        } catch {
//            print("预测失败: \(error.localizedDescription)")
//        }
//    }
//}
