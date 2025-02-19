////
////  ImagePrediction.swift
////  Purine Help
////
////  Created by 涂庭鋆 on 2025/2/18.
////
//
import SwiftUI
import CoreML
import Combine

@MainActor
class ImagePredictionModel: ObservableObject {
    
    // MARK: - Properties
    private var model: Food101  // The generated model class from MLProgram
    
    // Input image to predict on
    @Published var inputImage: UIImage? = nil
    
    // Output prediction result
    @Published var predictedClassLabel: String = ""
    @Published var isLoading: Bool = false
    @Published var predictionError: String? = nil
    
    // MARK: - Initializer
    init() {
        // Load the Core ML model from the .mlpackage (automatically generated Model class)
        guard let model = try? Food101(configuration: MLModelConfiguration()) else {
            fatalError("Model not loaded properly")
        }
        self.model = model
    }
    
    // MARK: - Prediction Logic
    func predictImage() {
        guard let image = inputImage else { return }
        
        // Start loading
        isLoading = true
        predictionError = nil
        
        // Convert image to CVPixelBuffer
        guard let pixelBuffer = uiImageToPixelBuffer(image: image, width: 224, height: 224) else {
            predictionError = "Failed to preprocess image"
            isLoading = false
            return
        }
        
        // Perform prediction
        performPrediction(pixelBuffer: pixelBuffer)
    }
    
    private func performPrediction(pixelBuffer: CVPixelBuffer) {
            // Perform prediction on a background thread
        Task {
            do {
                // Prediction is async now
                
                let input = Food101Input(mobilenetv2_1_00_224_input: pixelBuffer)
                let prediction = try model.prediction(input: input)
                
                // Update UI on the main thread
                self.predictedClassLabel = prediction.classLabel
                self.isLoading = false
            } catch {
                // Handle errors in prediction
                self.predictionError = "Prediction failed: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    private func uiImageToPixelBuffer(image: UIImage, width: Int, height: Int) -> CVPixelBuffer? {
        // Define pixel buffer attributes
        let attributes: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32ARGB,
            attributes as CFDictionary,
            &pixelBuffer
        )
        
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buffer, .init(rawValue: 0))
        guard let context = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        ) else {
            CVPixelBufferUnlockBaseAddress(buffer, .init(rawValue: 0))
            return nil
        }
        
        guard let cgImage = image.cgImage else {
            CVPixelBufferUnlockBaseAddress(buffer, .init(rawValue: 0))
            return nil
        }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(buffer, .init(rawValue: 0))
        
        return buffer
    }
    
}
