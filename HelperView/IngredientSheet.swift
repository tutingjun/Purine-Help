//
//  SwiftUIView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/19.
//

import SwiftUI

struct IngredientSheet: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("How is the purine level categorized?")
                        .font(.system(size: 30, weight: .heavy))
                        .padding(.bottom)
                    
                    Text(
                        "Purines are natural compounds found in various foods, and their breakdown in the body produces uric acid. We categorize foods based on their purine content as:"
                    )
                    .font(.system(size: 18))
                    .lineSpacing(8)
                    
                    
                    VStack(alignment: .leading, spacing: 20) {
                        RiskLevelCard(
                            tagImage: Helper.tagImage(tag: "high"), "Purine level: > 200mg/ 100g", "High Risk", "It’s advisable to limit or avoid these, as they significantly contribute to increased uric acid levels. Examples include organ meats and specific fish varieties.")
                        
                        RiskLevelCard(
                            tagImage: Helper.tagImage(tag: "medium"),"Purine level: 100 - 200mg/ 100g", "Medium Risk", "Moderation is key when consuming these items, which encompass certain meats and seafood.")
                        
                        RiskLevelCard(
                            tagImage: Helper.tagImage(tag: "low"), "Purine Level: < 100mg/ 100g", "Low Risk", "These are generally safe for consumption and include most fruits, vegetables, and grains.")
                    }
                    
                    Text(
                        "This categorization aligns with dietary recommendations aimed at managing uric acid levels and is supported by data from the USDA’s [“Purine Content of Foods” database](https://www.ars.usda.gov/northeast-area/beltsville-md-bhnrc/beltsville-human-nutrition-research-center/methods-and-application-of-food-composition-laboratory/mafcl-site-pages/purine-content-of-foods/)."
                    )
                    .font(.system(size: 18))
                    .lineSpacing(8)
                    
                }
                .padding()
                .toolbar{
                    ToolbarItem{
                        Button{
                            isPresented = false
                        } label:{
                            Image(systemName: "xmark.circle")
                                .foregroundStyle(Color.secondary)
                        }
                    }
                    
                }
            }
        }
    }

    @ViewBuilder
    func RiskLevelCard(tagImage: some View, _ title: String, _ subtitle: String, _ description: String)
        -> some View
    {
        VStack(spacing: 10){
            HStack(spacing: 15) {
                tagImage
                    .font(.system(size: 20))
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .fontWeight(.semibold)
                    Text(subtitle)
                        .font(.callout)
                        .foregroundStyle(Color.gray)
                }
                Spacer()
            }
            Text(description)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    IngredientSheet(isPresented: .constant(false))
}
