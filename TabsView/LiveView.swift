//
//  LiveView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/18.
//

import SwiftUI

struct LiveView: View {
    @EnvironmentObject private var viewModel: VideoViewModel
    @EnvironmentObject private var food: FoodPurineStore
    @EnvironmentObject private var user: UserStore
    
    var body: some View {
        ZStack {
            // Camera Feed
            if viewModel.isCameraReady{
                CameraViewRepresentable(viewModel: viewModel)
                VStack {
                                Spacer()
                                Text(viewModel.predictedClassLabel)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(10)
                                    .padding(.bottom, 50)
                            }
                
//                if !viewModel.predictedClassLabel.isEmpty {
//                    if let dish = food.getDishByName(viewModel.predictedClassLabel) {
//                        NavigationLink {
//                            DishDetailedView(dish: dish, isFavorite: user.isDishFav(dish))
//                                .environmentObject(user)
//                        } label: {
//                            Text("🍽️ " + dish.name.capitalized)
//                                .fontWeight(.semibold)
//                                .font(.headline)
//                                .padding(.vertical, 6)
//                        }
//                    }
//                }
            } else {
                Text("Camera not available")
            }
            
        }
        .onAppear {
            viewModel.startCaptureSession()
        }
        .onDisappear {
            viewModel.teardownAVCapture()
        }
    }
}
