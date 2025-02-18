//
//  SwiftUIView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/17.
//

import SwiftUI

struct DishDetailedView: View {
    var dish: DishDetail
    
    var body: some View {
        NavigationStack{
            HStack{
                ScrollView{
                    VStack (alignment: .leading, spacing: 20){
                        Text(dish.name.capitalized)
                            .font(.system(size: 34, weight: .heavy))
                        
                
                        VStack(alignment: .leading){
                            Text("Description")
                                .font(.callout)
                                .foregroundStyle(.gray)
                            Text("Chicken wings are a popular appetizer or snack consisting of chicken wing sections, typically deep-fried or baked. They are often coated in sauces ranging from mild to extremely spicy, and served with dips like ranch or blue cheese dressing. A common pub food!")
                                .lineSpacing(4)
                        }
                        
                        
                        VStack(alignment: .leading){
                            Text("Possible Ingredients")
                                .font(.callout)
                                .foregroundStyle(.gray)
                                .padding(.bottom, 1)
                            VStack(alignment: .leading, spacing: 5){
                                ForEach(dish.ingredients){ ingredient in
                                    NavigationLink {
                                        IngredientDetailedView(ingredient: ingredient)
                                    } label: {
                                        VStack{
                                            HStack{
                                                VStack(alignment: .leading, spacing: 3) {
                                                    Text(Helper.ingredientCat(category: ingredient.category) + " " + ingredient.name)
                                                        .fontWeight(.semibold)
                                                        .font(.headline)
                                                    HStack(spacing: 1) {
                                                        Text("Purine Level: ")
                                                        Text(ingredient.tag.capitalized)
                                                            .foregroundStyle(Helper.tagColor(tag: ingredient.tag))
                                                            .fontWeight(.medium)
                                                    }
                                                    .font(.system(size: 14))
                                                }
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .foregroundStyle(.secondary)
                                            }
                                            Divider()
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            
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
    var test =  DishDetail(id: UUID(), name: "Spaghetti Bolognese", ingredients: [
        IngredientDetail(id: 1, category: "Pasta", name: "Spaghetti", purine_count: "Medium", tag: "medium"),
        IngredientDetail(id: 2, category: "Meat", name: "Ground Beef", purine_count: "High", tag: "high")
    ])
    DishDetailedView(dish: test)
}
