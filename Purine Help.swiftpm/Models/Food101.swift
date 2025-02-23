//
// Food101.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
class Food101Input : MLFeatureProvider {

    /// mobilenetv2_1_00_224_input as color (kCVPixelFormatType_32BGRA) image buffer, 224 pixels wide by 224 pixels high
    var mobilenetv2_1_00_224_input: CVPixelBuffer

    var featureNames: Set<String> { ["mobilenetv2_1_00_224_input"] }

    func featureValue(for featureName: String) -> MLFeatureValue? {
        if featureName == "mobilenetv2_1_00_224_input" {
            return MLFeatureValue(pixelBuffer: mobilenetv2_1_00_224_input)
        }
        return nil
    }

    init(mobilenetv2_1_00_224_input: CVPixelBuffer) {
        self.mobilenetv2_1_00_224_input = mobilenetv2_1_00_224_input
    }

    convenience init(mobilenetv2_1_00_224_inputWith mobilenetv2_1_00_224_input: CGImage) throws {
        self.init(mobilenetv2_1_00_224_input: try MLFeatureValue(cgImage: mobilenetv2_1_00_224_input, pixelsWide: 224, pixelsHigh: 224, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!)
    }

    convenience init(mobilenetv2_1_00_224_inputAt mobilenetv2_1_00_224_input: URL) throws {
        self.init(mobilenetv2_1_00_224_input: try MLFeatureValue(imageAt: mobilenetv2_1_00_224_input, pixelsWide: 224, pixelsHigh: 224, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!)
    }

    func setMobilenetv2_1_00_224_input(with mobilenetv2_1_00_224_input: CGImage) throws  {
        self.mobilenetv2_1_00_224_input = try MLFeatureValue(cgImage: mobilenetv2_1_00_224_input, pixelsWide: 224, pixelsHigh: 224, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!
    }

    func setMobilenetv2_1_00_224_input(with mobilenetv2_1_00_224_input: URL) throws  {
        self.mobilenetv2_1_00_224_input = try MLFeatureValue(imageAt: mobilenetv2_1_00_224_input, pixelsWide: 224, pixelsHigh: 224, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!
    }

}


/// Model Prediction Output Type
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
class Food101Output : MLFeatureProvider {

    /// Source provided by CoreML
    private let provider : MLFeatureProvider

    /// classLabel as string value
    var classLabel: String {
        provider.featureValue(for: "classLabel")!.stringValue
    }

    /// classLabel_probs as dictionary of strings to doubles
    var classLabel_probs: [String : Double] {
        provider.featureValue(for: "classLabel_probs")!.dictionaryValue as! [String : Double]
    }

    var featureNames: Set<String> {
        provider.featureNames
    }

    func featureValue(for featureName: String) -> MLFeatureValue? {
        provider.featureValue(for: featureName)
    }

    init(classLabel: String, classLabel_probs: [String : Double]) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["classLabel" : MLFeatureValue(string: classLabel), "classLabel_probs" : MLFeatureValue(dictionary: classLabel_probs as [AnyHashable : NSNumber])])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
class Food101 {
    let model: MLModel

    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "Food101", withExtension:"mlmodelc")!
    }

    /**
        Construct Food101 instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of Food101.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `Food101.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(model: MLModel) {
        self.model = model
    }

    /**
        Construct a model with configuration

        - parameters:
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    convenience init(configuration: MLModelConfiguration = MLModelConfiguration()) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct Food101 instance with explicit path to mlmodelc file
        - parameters:
           - modelURL: the file url of the model

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }

    /**
        Construct a model with URL of the .mlmodelc directory and configuration

        - parameters:
           - modelURL: the file url of the model
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }

    /**
        Construct Food101 instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<Food101, Error>) -> Void) {
        load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }

    /**
        Construct Food101 instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
    */
    class func load(configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> Food101 {
        try await load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct Food101 instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<Food101, Error>) -> Void) {
        MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let model):
                handler(.success(Food101(model: model)))
            }
        }
    }

    /**
        Construct Food101 instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
    */
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> Food101 {
        let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
        return Food101(model: model)
    }

    /**
        Make a prediction using the structured interface

        It uses the default function if the model has multiple functions.

        - parameters:
           - input: the input to the prediction as Food101Input

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as Food101Output
    */
    func prediction(input: Food101Input) throws -> Food101Output {
        try prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        It uses the default function if the model has multiple functions.

        - parameters:
           - input: the input to the prediction as Food101Input
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as Food101Output
    */
    func prediction(input: Food101Input, options: MLPredictionOptions) throws -> Food101Output {
        let outFeatures = try model.prediction(from: input, options: options)
        return Food101Output(features: outFeatures)
    }

    /**
        Make an asynchronous prediction using the structured interface

        It uses the default function if the model has multiple functions.

        - parameters:
           - input: the input to the prediction as Food101Input
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as Food101Output
    */
    @available(macOS 14.0, iOS 17.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *)
    func prediction(input: Food101Input, options: MLPredictionOptions = MLPredictionOptions()) async throws -> Food101Output {
        let outFeatures = try await model.prediction(from: input, options: options)
        return Food101Output(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        It uses the default function if the model has multiple functions.

        - parameters:
            - mobilenetv2_1_00_224_input: color (kCVPixelFormatType_32BGRA) image buffer, 224 pixels wide by 224 pixels high

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as Food101Output
    */
    func prediction(mobilenetv2_1_00_224_input: CVPixelBuffer) throws -> Food101Output {
        let input_ = Food101Input(mobilenetv2_1_00_224_input: mobilenetv2_1_00_224_input)
        return try prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface

        It uses the default function if the model has multiple functions.

        - parameters:
           - inputs: the inputs to the prediction as [Food101Input]
           - options: prediction options

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [Food101Output]
    */
    func predictions(inputs: [Food101Input], options: MLPredictionOptions = MLPredictionOptions()) throws -> [Food101Output] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [Food101Output] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  Food101Output(features: outProvider)
            results.append(result)
        }
        return results
    }
}
