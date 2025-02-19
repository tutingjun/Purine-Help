//
//  SwiftUIView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/18.
//

import SwiftUI

struct ContentView: View {
    @StateObject var foodStore = FoodPurineStore(named: "test")
    @StateObject var imagePrediction = ImagePredictionModel()
    
    var body: some View {
        if foodStore.isLoading {
            LoadingView()
        } else {
            TabView {
                SearchView()
                    .environmentObject(foodStore)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                CameraView()
                    .environmentObject(imagePrediction)
                    .tabItem{
                        Label("Recognize", systemImage: "camera")
                    }
            }

        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
            Text("Fetching data, please wait...")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.8))  // Light overlay effect
    }
}

#Preview {
    ContentView()
}
