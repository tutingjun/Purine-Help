//
//  SwiftUIView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/17.
//

import SwiftUI

struct IngredientDetailedView: View {
    var ingredient: IngredientDetail
    
    var body: some View {
        NavigationStack{
            HStack{
                ScrollView{
                    VStack (alignment: .leading, spacing: 20){
                        Text(ingredient.name)
                            .font(.system(size: 34, weight: .heavy))
                        VStack(alignment: .leading){
                            Text("Category")
                                .font(.callout)
                                .foregroundStyle(.gray)
                            Text(Helper.ingredientCat(category: ingredient.category) + " " + ingredient.category)
                                .font(.headline)
                        }
                        
                        VStack(alignment: .leading){
                            Text("Purine content (per 100 g):")
                                .font(.callout)
                                .foregroundStyle(.gray)
                            Text(Helper.formatStringToNearestThousandth(ingredient.purine_count) + " mg")
                                .font(.headline)
                        }
                        
                        VStack(alignment: .leading){
                            Text("Threat Level:")
                                .font(.callout)
                                .foregroundStyle(.gray)
                            HStack (spacing: 3){
                                Helper.tagImage(tag: ingredient.tag)
                                Text(ingredient.tag.capitalized)
                                    .font(.headline)
                            }
                        }
                        
                        VStack(alignment: .leading){
                            Text("Safety Advice")
                                .font(.callout)
                                .foregroundStyle(.gray)
                            Text("Fresh parsley, despite being a vegetable, exhibits a surprisingly high purine content of 289.3 mg per 100g. This level is significant, approaching that of some moderate-purine meats. While parsley is often used in small quantities as a garnish, individuals adhering to a strict low-purine diet, particularly those with gout, should be mindful of their intake. Consider using lower-purine herbs and vegetables for flavor enhancement. As always, consult with a healthcare professional or registered dietitian for personalized dietary advice regarding purine management.")
                                .lineSpacing(4)
                        }
                        
                        Spacer()
                    }
                    Spacer()
                }
                .edgesIgnoringSafeArea(.horizontal)
            }
            .padding()
        }
    }
}

#Preview {
    IngredientDetailedView(ingredient: IngredientDetail(id: 1, category: "Cereal grains and grain-based products", name: "Rice, white, raw", purine_count: "32.6", tag: "medium"))
}
