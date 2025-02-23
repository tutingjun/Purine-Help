//
//  LiveView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/18.
//

import SwiftUI

@available(iOS 18.0, *)
struct LiveView: View {
    @EnvironmentObject private var camera: DetectionModel
    @EnvironmentObject private var food: FoodPurineStore
    @EnvironmentObject private var user: UserStore

    var body: some View {
        NavigationView {
            ZStack {
                // Camera Feed
                if camera.isCameraReady {
                    CameraViewRepresentable(viewModel: camera)
                        .edgesIgnoringSafeArea(.top)
                    VStack {
                        HStack {
                            Spacer()
                            HStack {
                                Text("Start Prediction: ")
                                Toggle(
                                    "Start Prediction: ",
                                    isOn: $camera.isDetecting
                                )
                                .labelsHidden()
                            }
                            .padding(10)
                            .background(Color.white.opacity(0.8))
                            .foregroundColor(.black)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                        }
                        .padding()

                        Spacer()

                        if !camera.predictedClassLabel.isEmpty
                            && camera.isDetecting
                        {
                            if let dish = food.getDishByName(
                                camera.predictedClassLabel)
                            {
                                NavigationLink {
                                    DishDetailedView(
                                        dish: dish,
                                        isFavorite: user.isDishFav(dish)
                                    )
                                    .environmentObject(user)
                                    .environmentObject(food)
                                } label: {
                                    HStack(spacing: 20) {
                                        Text("🍽️  " + dish.name.capitalized)
                                            .font(
                                                .system(
                                                    size: 32, weight: .semibold)
                                            )
                                        Image(systemName: "chevron.right")
                                            .font(
                                                .system(
                                                    size: 16, weight: .semibold)
                                            )
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.8))
                                    .foregroundColor(.black)
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                                    .padding()
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }

                } else {
                    Text("Camera not available")
                }

            }
            .task {
                await camera.start()
            }
            .onDisappear {
                camera.stop()
            }
        }
    }
}

#Preview {
    if #available(iOS 18.0, *) {
        LiveView()
            .environmentObject(DetectionModel())
            .environmentObject(UserStore())
            .environmentObject(FoodPurineStore())
    } else {
        // Fallback on earlier versions
    }

}
