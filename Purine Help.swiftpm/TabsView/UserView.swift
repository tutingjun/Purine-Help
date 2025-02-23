//
//  SwiftUIView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/20.
//

import SwiftUI

struct UserView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var user: UserStore
    @EnvironmentObject var food: FoodPurineStore

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {

                if user.userFavIngredient.isEmpty && user.userFavDish.isEmpty {
                    HStack {
                        Spacer()
                        VStack(alignment: .leading, spacing: 10) {
                            Text("No favorite yet!")
                                .font(.system(size: 21))

                            Text("Try pressing the ").foregroundColor(.secondary)
                                + Text(Image(systemName: "star"))
                                .foregroundColor(.secondary)
                                + Text(
                                    " icon next to the food/dish name to add it to your favorites."
                                )
                                .foregroundColor(.secondary)
                        }

                        Spacer()
                    }
                    .padding()
                }

                if !user.userFavIngredient.isEmpty {
                    HStack {
                        Text("🥕 Ingredients")
                            .font(.system(size: 20, weight: .semibold))
                        Spacer()
                        if user.userFavIngredient.count > 4 {
                            NavigationLink {
                                FavoriteIngredientFilter()
                                    .environmentObject(user)
                                    .environmentObject(food)
                            } label: {
                                Text("View More")
                            }
                        }
                    }

                    LazyVGrid(columns: columns) {
                        ForEach(user.userFavIngredient.prefix(4), id: \.self) {
                            ingredient in
                            NavigationLink {
                                IngredientDetailedView(
                                    ingredient: ingredient,
                                    isFavorite: true,
                                    fromSearch: false
                                )
                                .environmentObject(user)
                                .environmentObject(food)
                            } label: {
                                IngredientCard(ingredient)
                            }
                            .buttonStyle(PlainButtonStyle())

                        }
                    }
                    .padding(.bottom)
                }

                if !user.userFavDish.isEmpty {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("🍽️  Dishes")
                                .font(.system(size: 20, weight: .semibold))
                            Spacer()
                            EditButton()
                                .padding(.trailing, 5)

                        }

                        List {
                            ForEach(user.userFavDish) { dish in
                                NavigationLink {
                                    DishDetailedView(
                                        dish: dish, isFavorite: true,
                                        fromSearch: false
                                    )
                                    .environmentObject(user)
                                    .environmentObject(food)
                                } label: {
                                    HStack{
                                        Text(dish.name.capitalized)
                                            .fontWeight(.semibold)
                                            .font(.headline)
                                            .padding(.vertical, 3)
                                        Spacer()
                                    }
                                    .contentShape(Rectangle())
                                }
                            }
                            .onDelete(perform: user.removeFavDish(at:))
                        }
                        .listStyle(.inset)
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Favorites")
        }
    }

    @ViewBuilder
    private func IngredientCard(_ ingredient: IngredientDetail) -> some View {
        VStack(alignment: .leading) {
            Text(ingredient.name)
                .font(.system(size: 18, weight: .semibold))
            Divider()
                .overlay(colorScheme == .light ? Color.secondary : Color.white)
            HStack {
                Helper.tagImage(tag: ingredient.tag)
                Text(
                    Helper.formatStringToNearestThousandth(
                        ingredient.purine_count) + " mg"
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 90)
        .padding()
        .background(
            colorScheme == .light ? Color.white : Color.init(hex: "#18181b")
        )
        .cornerRadius(12)
        .modifier(ShadowModifier())
        .padding(.bottom, 6)
    }
}

struct ShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.clear)
            )
            .shadow(color: Color.black.opacity(0.02), radius: 5, x: 0, y: 0)
            .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 2)
            .shadow(color: Color.black.opacity(0.3), radius: 1, x: 0, y: 0)
    }
}

#Preview {
    UserView()
        .environmentObject(UserStore())
        .environmentObject(FoodPurineStore())
}
