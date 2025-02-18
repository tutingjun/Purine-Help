import SwiftUI

@main
struct MyApp: App {
    @StateObject var foodStore = FoodPurineStore(named: "test", shouldLoadData: true)

    var body: some Scene {
        WindowGroup {
            SearchView()
                .environmentObject(foodStore)
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
        .background(Color.white.opacity(0.8)) // Light overlay effect
    }
}
