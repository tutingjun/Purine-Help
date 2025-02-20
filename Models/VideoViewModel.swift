///*
//See the LICENSE.txt file for this sample’s licensing information.
//
//Abstract:
//Contains the object recognition view controller for the Breakfast Finder.
//*/
//
//import CoreImage
//import AVFoundation
//import Vision
//
//class VideoViewModel: VideoViewController, ObservableObject {
//
//    // Vision parts
//    private var model: Food101  // The generated Core ML model class
//    @Published var predictedClassLabel: String = ""
//
//
//    override init() {
//        guard let model = try? Food101(configuration: MLModelConfiguration())
//        else {
//            fatalError("Model not loaded properly")
//        }
//        self.model = model
//        super.init()
//        self.startCaptureSession()
//    }
//
//    override func captureOutput(
//        _ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer,
//        from connection: AVCaptureConnection
//    ) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
//        else {
//            return
//        }
//        
//        guard let bgraPixelBuffer = convertToBGRA(pixelBuffer) else {
//                print("Failed to convert YUV to BGRA")
//                return
//            }
//        
//        guard let resizedPixelBuffer = resizePixelBuffer(bgraPixelBuffer, width: 224, height: 224) else {
//                print("Failed to resize image to 224x224")
//                return
//            }
//
//        do {
//            let input = Food101Input(mobilenetv2_1_00_224_input: resizedPixelBuffer)
//            let prediction = try model.prediction(input: input)
//            predictedClassLabel = prediction.classLabel
//            print(prediction.classLabel)
//            // Ensure UI updates happen on the main actor
//
//        } catch {
//            print("Prediction failed: \(error.localizedDescription)")
//
//        }
//    }
//    
//    func resizePixelBuffer(_ pixelBuffer: CVPixelBuffer, width: Int, height: Int) -> CVPixelBuffer? {
//        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
//        let context = CIContext()
//
//        let resizedImage = ciImage.transformed(by: CGAffineTransform(scaleX: CGFloat(width) / CGFloat(CVPixelBufferGetWidth(pixelBuffer)),
//                                                                     y: CGFloat(height) / CGFloat(CVPixelBufferGetHeight(pixelBuffer))))
//
//        var resizedPixelBuffer: CVPixelBuffer?
//        let attributes = [
//            kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA,
//            kCVPixelBufferWidthKey: width,
//            kCVPixelBufferHeightKey: height
//        ] as CFDictionary
//
//        CVPixelBufferCreate(
//            kCFAllocatorDefault,
//            width,
//            height,
//            kCVPixelFormatType_32BGRA,
//            attributes,
//            &resizedPixelBuffer
//        )
//
//        if let resizedPixelBuffer = resizedPixelBuffer {
//            context.render(resizedImage, to: resizedPixelBuffer)
//            return resizedPixelBuffer
//        }
//
//        return nil
//    }
//    
//    func convertToBGRA(_ pixelBuffer: CVPixelBuffer) -> CVPixelBuffer? {
//        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
//        let context = CIContext()
//
//        var bgraPixelBuffer: CVPixelBuffer?
//        let attributes = [
//            kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA,
//            kCVPixelBufferWidthKey: CVPixelBufferGetWidth(pixelBuffer),
//            kCVPixelBufferHeightKey: CVPixelBufferGetHeight(pixelBuffer)
//        ] as CFDictionary
//
//        CVPixelBufferCreate(
//            kCFAllocatorDefault,
//            CVPixelBufferGetWidth(pixelBuffer),
//            CVPixelBufferGetHeight(pixelBuffer),
//            kCVPixelFormatType_32BGRA,
//            attributes,
//            &bgraPixelBuffer
//        )
//
//        if let bgraPixelBuffer = bgraPixelBuffer {
//            context.render(ciImage, to: bgraPixelBuffer)
//            return bgraPixelBuffer
//        }
//
//        return nil
//    }
//
//}
