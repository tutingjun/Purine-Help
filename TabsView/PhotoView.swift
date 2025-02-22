import SwiftUI
import PhotosUI

struct PhotoView: View {    
    @EnvironmentObject private var viewModel: ImagePredictionModel
    @EnvironmentObject private var food: FoodPurineStore
    @EnvironmentObject private var user: UserStore
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    HStack{
                        Text("Classify Image")
                            .font(.system(size: 36, weight: .heavy))
                        Spacer()
                    }
                    .padding()
                    Spacer()

                    // Image Preview
                    if let image = viewModel.inputImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 250)
                            .cornerRadius(15)
                            .padding(.horizontal)
                    }
                    
                    // Prediction Results Card
                    if viewModel.isLoading {
                        ProgressView()
                            .padding()
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    } else if let error = viewModel.predictionError {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    } else if !viewModel.predictions.isEmpty {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Possible results:")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.leading, 10)
                            
                            // Prediction List
                            VStack(spacing: 10) {
                                ForEach(viewModel.predictions.prefix(3), id: \.label) { prediction in
                                    if let dish = food.getDishByName(prediction.label) {
                                        NavigationLink{
                                            DishDetailedView(dish: dish, isFavorite: user.isDishFav(dish))
                                                .environmentObject(user)
                                        } label: {
                                            VStack (spacing: 8){
                                                HStack {
                                                    Text(prediction.label.capitalized)
                                                        .font(.headline)
                                                    
                                                    Spacer()
                                                    
                                                    Text(String(format: "%.0f%%", prediction.confidence * 100))
                                                        .font(.headline)
                                                }
                                                
                                                
                                                ProgressView(value: prediction.confidence)
                                                    .progressViewStyle(LinearProgressViewStyle())
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                            
                                            
                                        }
                                    }
                                }
                            }
                            .padding(.vertical)
                            .padding(.leading, 10)
                            
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .foregroundStyle(Color.black)
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        .padding()
                    }
                    
                    selectImageButton()
                    Spacer()
                }

            }
            .onChange(of: selectedItem) { newItem in
                loadImage(from: newItem)
            }
        }
    }
    
    @ViewBuilder
    private func selectImageButton() -> some View{
        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
            Label("Select Image", systemImage: "photo")
                .padding()
                .background(Color.white.opacity(0.8))
                .foregroundColor(.black)
                .cornerRadius(12)
                .shadow(radius: 5)
        }
        .padding()
    }
    
    private func loadImage(from item: PhotosPickerItem?) {
        guard let item = item else { return }
        
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                selectedImage = uiImage
                viewModel.inputImage = uiImage
                viewModel.predictImage()
            }
        }
    }
}

#Preview {
    PhotoView()
        .environmentObject(ImagePredictionModel())
        .environmentObject(UserStore())
        .environmentObject(FoodPurineStore())
}
