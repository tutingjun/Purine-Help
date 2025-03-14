//
//  SwiftUIView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/17.
//

import SwiftUI

struct DishDetailedView: View {
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var user: UserStore
    @EnvironmentObject var food: FoodPurineStore
    var dish: DishDetail
    @State var isFavorite: Bool
    var fromSearch = true

    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(dish.name.capitalized)
                            .font(.system(size: 34, weight: .heavy))
                        Spacer()
                        Button {
                            if isFavorite {
                                user.removeFavDish(dish)
                            } else {
                                user.addFavDish(dish)
                            }
                            isFavorite.toggle()
                        } label: {
                            Image(systemName: isFavorite ? "star.fill" : "star")
                                .foregroundColor(isFavorite ? .orange : colorScheme == .light ? .black : .white)
                                .font(.system(size: 18))
                        }
                    }

                    VStack(alignment: .leading) {
                        Text("Description")
                            .font(.callout)
                            .foregroundStyle(.gray)
                        Text(dish.description)
                        .lineSpacing(4)
                    }

                    VStack(alignment: .leading) {
                        Text("Possible Ingredients")
                            .font(.callout)
                            .foregroundStyle(.gray)
                            .padding(.bottom, 1)
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(dish.ingredients) { ingredient in
                                NavigationLink {
                                    IngredientDetailedView(
                                        ingredient: ingredient,
                                        isFavorite: user.isIngredientFav(
                                            ingredient)
                                    )
                                    .environmentObject(user)
                                    .environmentObject(food)
                                } label: {
                                    makeIngredientRow(ingredient)
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
            .padding()
            .onDisappear {
                if fromSearch {
                    user.addRecentSearch(FoodItem.dish(dish))
                }
        }
    }

    @ViewBuilder
    private func makeIngredientRow(_ ingredient: IngredientDetail) -> some View
    {
        VStack {
            HStack {
                VStack(
                    alignment: .leading, spacing: 3
                ) {
                    Text(
                        Helper.ingredientCat(
                            category: ingredient
                                .category) + " "
                            + ingredient.name
                    )
                    .fontWeight(.semibold)
                    .font(.headline)
                    HStack(spacing: 1) {
                        Text("Purine Level: ")
                        Text(
                            ingredient.tag
                                .capitalized
                        )
                        .foregroundStyle(
                            Helper.tagColor(
                                tag: ingredient.tag)
                        )
                        .fontWeight(.medium)
                    }
                    .font(.system(size: 14))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .contentShape(Rectangle())

            Divider()
        }
    }
}

#Preview {
    var test = DishDetail(
        id: 2, name: "Spaghetti Bolognese",
        ingredients: [
            IngredientDetail(
                id: 1, category: "Pasta", name: "Spaghetti",
                purine_count: "12", tag: "medium", description: "12"),
            IngredientDetail(
                id: 2, category: "Meat", name: "Ground Beef",
                purine_count: "234", tag: "high", description: "12"),
        ],
        description: "123")
    DishDetailedView(dish: test, isFavorite: false)
        .environmentObject(UserStore())
        .environmentObject(FoodPurineStore())
}
