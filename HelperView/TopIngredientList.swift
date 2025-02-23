//
//  SwiftUIView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/22.
//

import SwiftUI

struct TopIngredientList: View {
    @EnvironmentObject var user: UserStore
    @EnvironmentObject var food: FoodPurineStore

    var categoryList: [IngredientDetail]
    var category: String

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text(Helper.transformCate(category).capitalized)
                            .font(.system(size: 36, weight: .heavy))
                            .padding(.bottom, 5)
                    }
                    .padding(.horizontal)

                    Text(Helper.ingredientCatDescription(category: category))
                        .lineSpacing(5)
                        .padding()

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Top 10 Lowest Purine")
                            .font(.subheadline)
                            .foregroundStyle(Color.gray)
                        Divider()
                    }
                    .padding(.horizontal)

                    ForEach(Array(categoryList.enumerated()), id: \.element.id)
                    {
                        index, ingredient in
                        NavigationLink {
                            IngredientDetailedView(
                                ingredient: ingredient,
                                isFavorite: user.isIngredientFav(ingredient)
                            )
                            .environmentObject(user)
                            .environmentObject(food)
                        } label: {
                            IngredientRow(ingredient, at: index)
                                .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.bottom)
            }
        }
    }

    @ViewBuilder
    private func IngredientRow(_ ingredient: IngredientDetail, at index: Int)
        -> some View
    {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                HStack(alignment: .top) {
                    Text("\(index + 1).")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(width: 30, alignment: .leading)
                    VStack(alignment: .leading, spacing: 5) {
                        Text(ingredient.name.capitalized)
                            .font(.system(size: 18, weight: .semibold))
                        HStack(spacing: 5) {
                            Helper.tagImage(tag: ingredient.tag)
                            Text(
                                Helper.formatStringToNearestThousandth(
                                    ingredient.purine_count) + " mg"
                            )
                        }
                        .font(.system(size: 14))
                    }
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.secondary)
            }
            Divider()
        }
        .contentShape(Rectangle())
        .padding(.vertical, 2)
    }
}

#Preview {
    TopIngredientList(
        categoryList: [
            IngredientDetail(
                id: 1, category: "Pasta", name: "Spaghetti",
                purine_count: "12", tag: "medium", description: "12"),
            IngredientDetail(
                id: 2, category: "Meat", name: "Ground Beef",
                purine_count: "234", tag: "high", description: "12"),
        ],
        category: "Legumes and legume products"
    )
    .environmentObject(UserStore())
    .environmentObject(FoodPurineStore())
}
