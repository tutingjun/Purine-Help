//
//  SwiftUIView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/17.
//

import SwiftUI

struct IngredientDetailedView: View {
    var ingredient: IngredientDetail
    @State var shouldPresentSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 35) {

                    VStack(alignment: .leading, spacing: 10) {
                        Text(ingredient.name)
                            .font(.system(size: 36, weight: .heavy))
                        Text(
                            ingredient.category
                        )
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(
                            Helper.cateToColorMap[ingredient.category]
                                ?? Color.gray
                        )
                        .clipShape(Capsule())
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

                        Text(
                            Helper.formatStringToNearestThousandth(
                                ingredient.purine_count) + " mg"
                        )
                        .font(.headline)

                        if ingredient.purine_count != "ND" {
                            SliderView(
                                currentValue: Double(
                                    ingredient.purine_count)!
                            )
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
    }
}

#Preview {
    IngredientDetailedView(
        ingredient: IngredientDetail(
            id: 1, category: "Vegetarian meat, fish, and egg alternatives",
            name: "Rice, white, raw", purine_count: "1111.6", tag: "medium"))
}
