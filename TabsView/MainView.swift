//
//  SwiftUIView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/21.
//

import SwiftUI

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject private var photo: ImagePredictionModel
    @EnvironmentObject private var food: FoodPurineStore
    @EnvironmentObject private var user: UserStore
    @EnvironmentObject private var camera: VideoViewModel

    
    var body: some View {
        NavigationStack{
            Spacer()
            VStack(spacing: 5) {
                HStack(spacing: 10){
                    Image(systemName: "carrot")
                        .font(.system(size: 30))
                        .foregroundColor(Color.init(hex: "#FF8C00"))
                    
                    Text("Purine Helper")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                Text("Your personalized purine level database")
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 20)
            
            // Image Selection Buttons
            HStack(spacing: 20) {
                NavigationLink {
                    LiveView()
                        .environmentObject(camera)
                        .environmentObject(food)
                        .environmentObject(user)
                } label: {
                    VStack{
                        Image(systemName: "camera.fill")
                            .font(.system(size: 50))
                            .padding(.bottom, 15)
                            .foregroundColor(Color.init(hex: "#1E90FF"))
                        
                        Text("Live Prediction")
                            .font(.headline)
                            .foregroundColor(colorScheme == .light ? .black : .white)

                        Text("Analyze food in real-time")
                            .lineLimit(2)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(width: 170, height: 180)
                    .background(
                        colorScheme == .light ? Color.white : Color.init(hex: "#18181b")
                    )
                    .cornerRadius(12)
                    .modifier(ShadowModifier())
                }
                
                NavigationLink {
                    PhotoView()
                        .environmentObject(photo)
                        .environmentObject(food)
                        .environmentObject(user)
                } label: {
                    VStack{
                        Image(systemName: "photo.fill.on.rectangle.fill")
                            .font(.system(size: 50))
                            .padding(.bottom, 15)
                            .foregroundColor(Color.init(hex: "#32CD32"))
                        
                        
                        Text("Predict Photos")
                            .font(.headline)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                        
                        Text("Upload an image to analyze")
                            .lineLimit(2)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(width: 170, height: 180)
                    .background(
                        colorScheme == .light ? Color.white : Color.init(hex: "#18181b")
                    )
                    .cornerRadius(12)
                    .modifier(ShadowModifier())
                }
            }
            .padding(.top, 20)
            
            Spacer()
            Spacer()
        }
    }
}
