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
    var dish: DishDetail
    @State var isFavorite: Bool
    var fromSearch = true

    var body: some View {
        NavigationView {
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
                        Text(
                            "Chicken wings are a popular appetizer or snack consisting of chicken wing sections, typically deep-fried or baked. They are often coated in sauces ranging from mild to extremely spicy, and served with dips like ranch or blue cheese dressing. A common pub food!"
                        )
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
        }
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
        id: UUID(), name: "Spaghetti Bolognese",
        ingredients: [
            IngredientDetail(
                id: 1, category: "Pasta", name: "Spaghetti",
                purine_count: "12", tag: "medium"),
            IngredientDetail(
                id: 2, category: "Meat", name: "Ground Beef",
                purine_count: "234", tag: "high"),
        ])
    DishDetailedView(dish: test, isFavorite: false)
        .environmentObject(UserStore())
}
