//
//  SwiftUIView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/17.
//

import SwiftUI

struct IngredientDetailedView: View {
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var user: UserStore
    var ingredient: IngredientDetail
    @State var isFavorite: Bool
    @State var shouldPresentSheet = false
    var fromSearch = true

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 35) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment:.firstTextBaseline){
                            Text(ingredient.name)
                                .font(.system(size: 36, weight: .heavy))
                            Spacer()
                            Button{
                                if isFavorite {
                                    user.removeFavIngredient(ingredient)
                                } else {
                                    user.addFavIngredient(ingredient)
                                }
                                isFavorite.toggle()
                            } label: {
                                Image(systemName: isFavorite ? "star.fill" : "star")
                                    .foregroundColor(isFavorite ? .orange : colorScheme == .light ? .black : .white)
                                    .font(.system(size: 18))
                            }
                        }
                        
                        NavigationLink{
//                            TopIngredientList(categoryList: [IngredientDetail], category: <#T##String#>)
                        } label: {
                            Text(
                                Helper.transformCate(ingredient.category).capitalized
                            )
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(
                                Helper.cateToColorMap[ingredient.category]!
                            )
                            .clipShape(Capsule())
                        }
                    }

                    VStack(alignment: .leading) {
                        HStack(alignment: .center) {
                            Text("Purine content (per 100 g):")
                                .font(.callout)
                                .foregroundStyle(.gray)
                            Button {
                                shouldPresentSheet.toggle()
                            } label: {
                                Image(systemName: "info.circle")
                                    .foregroundStyle(Color.blue)
                            }
                        }

                        HStack{
                            Helper.tagImage(tag: ingredient.tag)
                            Text(
                                Helper.formatStringToNearestThousandth(
                                    ingredient.purine_count) + " mg"
                            )
                            .font(.headline)
                        }
                        

                        if ingredient.purine_count != "ND" {
                            SliderView(
                                currentValue: Double(
                                    ingredient.purine_count)!
                            )
                            .padding(.top, 10)
                            .padding(.bottom, 25)
                        }
                    }

                    VStack(alignment: .leading) {
                        Text("Safety Advice")
                            .font(.callout)
                            .foregroundStyle(.gray)
                        Text(
                            "Fresh parsley, despite being a vegetable, exhibits a surprisingly high purine content of 289.3 mg per 100g. This level is significant, approaching that of some moderate-purine meats. While parsley is often used in small quantities as a garnish, individuals adhering to a strict low-purine diet, particularly those with gout, should be mindful of their intake. Consider using lower-purine herbs and vegetables for flavor enhancement. As always, consult with a healthcare professional or registered dietitian for personalized dietary advice regarding purine management."
                        )
                        .lineSpacing(8)

                    }

                }
                .padding(.horizontal, 5)
            }
            .edgesIgnoringSafeArea(.horizontal)
            .padding()
            .sheet(isPresented: $shouldPresentSheet) {
                print("Sheet dismissed!")
            } content: {
                IngredientSheet(isPresented: $shouldPresentSheet)

            }

        }
        .onDisappear{
            if fromSearch {
                user.addRecentSearch(FoodItem.ingredient(ingredient))
            }
        }
    }
}

#Preview {
    IngredientDetailedView(
        ingredient: IngredientDetail(
            id: 1, category: "Vegetarian meat, fish, and egg alternatives",
            name: "Rice, whitsdadsadadsadadasdase, raw", purine_count: "5.9", tag: "low"), isFavorite: false)
    .environmentObject(UserStore())
}
