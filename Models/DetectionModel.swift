//
//  DetectionModel.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/21.
//

import SwiftUI
import CoreML

@available(iOS 18.0, *)
class DetectionModel: CameraManager {
    
    private var model: Food101
    private var predictedLabelsHistory: [String] = []
    @Published var predictedClassLabel: String = ""
    @Published var isDetecting: Bool = false {
        didSet {
            if isDetecting {
                print("start")
            } else {
                print("stop")
                self.predictedClassLabel = ""

            }
        }
    }

    override init() {
        guard let model = try? Food101(configuration: MLModelConfiguration())
        else {
            fatalError("Model not loaded properly")
        }
        self.model = model
        super.init()
        Task {
            await handleVisionObservations()
        }
    }

    private func handleVisionObservations() async {
        for await resizedPixelBuffer in previewStream {
            Task { @MainActor in
                if isDetecting {
                    do {
                        let input = Food101Input(
                            mobilenetv2_1_00_224_input: resizedPixelBuffer)
                        let prediction = try model.prediction(input: input)
                        let predictedLabel = prediction.classLabel
                        predictedLabelsHistory.append(predictedLabel)
                        if predictedLabelsHistory.count > 30 {
                            predictedLabelsHistory.removeFirst()
                        }

                        let labelCounts = Dictionary(
                            predictedLabelsHistory.map { ($0, 1) },
                            uniquingKeysWith: +)
                        predictedClassLabel =
                            labelCounts.max { $0.value < $1.value }?.key ?? ""

                    } catch {
                        print(
                            "Prediction failed: \(error.localizedDescription)")

                    }
                }
            }
        }
    }

}
