//
//  SwiftUIView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/18.
//

import SwiftUI

struct CameraView: View {
    @EnvironmentObject var imagePrediction: ImagePredictionModel
    
    @State private var selectedImage: UIImage?
    
    var body: some View {
        NavigationStack{
            VStack {
                // Display the selected image if any
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                } else {
                    Text("No Image Selected")
                        .padding()
                }
                
                // Display prediction result or loading state
                if imagePrediction.isLoading {
                    ProgressView("Predicting...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else {
                    Text(imagePrediction.predictedClassLabel)
                        .font(.title)
                        .padding()
                }
                
                // Display error if any
                if let error = imagePrediction.predictionError {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                // Button to trigger image selection
                Button("Select Image") {
                    selectImage()
                }
                .padding()
                
                // Button to trigger prediction
                Button("Predict") {
                    // Pass selected image to view model for prediction
                    imagePrediction.inputImage = selectedImage
                    imagePrediction.predictImage()
                }
                .padding()
                .disabled(selectedImage == nil)
            }
            .navigationTitle("Purine Helper")
        }
        
    }
    
    // Function to pick an image from the photo library
    private func selectImage() {
        // This part should be integrated with an image picker (e.g., UIImagePickerController)
        // For simplicity, I am setting a test image from assets directly:
        if let image = UIImage(named: "TestImage") {
            selectedImage = image
        }
    }
}

#Preview {
    CameraView()
}
