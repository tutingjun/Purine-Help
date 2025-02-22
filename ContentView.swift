//
//  SwiftUIView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/18.
//

import SwiftUI

@available(iOS 18.0, *)
struct ContentView: View {
    @StateObject var userStore = UserStore()
    @StateObject var foodStore = FoodPurineStore()
    @StateObject var imagePrediction = ImagePredictionModel()
    @StateObject var videoPrediction = DetectionModel()
    
    var body: some View {
        if foodStore.isLoading {
            LoadingView()
        } else {
            TabView {
                MainView()
                    .environmentObject(videoPrediction)
                    .environmentObject(imagePrediction)
                    .environmentObject(foodStore)
                    .environmentObject(userStore)
                    .tabItem{
                        Label("Predict", systemImage: "fork.knife")
                    }
                
                SearchView()
                    .environmentObject(foodStore)
                    .environmentObject(userStore)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                
                UserView()
                    .environmentObject(userStore)
                    .tabItem {
                        Label("Favorites", systemImage: "star")
                    }
                
                TopView()
                    .environmentObject(foodStore)
                    .environmentObject(userStore)
                    .tabItem {
                        Label("Top", systemImage: "list.number")
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
    if #available(iOS 18.0, *) {
        ContentView()
    } else {
        // Fallback on earlier versions
    }
}
