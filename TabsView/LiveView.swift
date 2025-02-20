//
//  LiveView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/18.
//

import SwiftUI

struct LiveView: View {
//    @EnvironmentObject private var viewModel: VideoViewModel
    
    var body: some View {
        ZStack {
            // Camera Feed
//            CameraViewRepresentable(viewModel: viewModel)
//                .edgesIgnoringSafeArea(.all)
            
            // Overlay for Predicted Label
            VStack {
                Spacer()
                Text("Test")
//                Text(viewModel.predictedClassLabel)
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.black.opacity(0.7))
//                    .cornerRadius(10)
//                    .padding(.bottom, 50)
            }
        }
//        .onAppear {
//            viewModel.startCaptureSession()
//        }
//        .onDisappear {
//            viewModel.teardownAVCapture()
//        }
    }
}
