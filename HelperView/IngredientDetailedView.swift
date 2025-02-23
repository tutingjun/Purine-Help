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
    @EnvironmentObject var food: FoodPurineStore

    var ingredient: IngredientDetail
    @State var isFavorite: Bool
    @State var shouldPresentSheet = false
    var fromSearch = true

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 35) {

                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(ingredient.name)
                                .font(.system(size: 36, weight: .heavy))
                            Spacer()
                            Button {
                                if isFavorite {
                                    user.removeFavIngredient(ingredient)
                                } else {
                                    user.addFavIngredient(ingredient)
                                }
                                isFavorite.toggle()
                            } label: {
                                Image(
                                    systemName: isFavorite
                                        ? "star.fill" : "star"
                                )
                                .foregroundColor(
                                    isFavorite
                                        ? .orange
                                        : colorScheme == .light
                                            ? .black : .white
                                )
                                .font(.system(size: 18))
                            }
                        }

                        Text(
                            Helper.transformCate(ingredient.category)
                                .capitalized
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

                        HStack {
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
                        Text(ingredient.description)
                            .lineSpacing(8)
                    }
                    
                    if let dishList = food.ingredientToDishes[ingredient.id]{
                        if !dishList.isEmpty{
                            VStack(alignment: .leading, spacing: 3){
                                Text("Dishes containing \(ingredient.name)")
                                    .font(.callout)
                                    .foregroundStyle(.gray)
                                ForEach(dishList, id: \.self){ dish in
                                    DishRow(dish)
                                        .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }

                }
                .padding(.horizontal, 5)
            }
            .edgesIgnoringSafeArea(.horizontal)
            .padding()
            .sheet(isPresented: $shouldPresentSheet) {
            } content: {
                IngredientSheet(isPresented: $shouldPresentSheet)

            }

        }
        .onDisappear {
            if fromSearch {
                user.addRecentSearch(FoodItem.ingredient(ingredient))
            }
        }
    }
    
    @ViewBuilder
    private func DishRow(_ dish: DishDetail) -> some View {
        NavigationLink {
            DishDetailedView(dish: dish, isFavorite: user.isDishFav(dish))
                .environmentObject(user)
                .environmentObject(food)
        } label: {
            VStack(spacing: 5){
                HStack{
                    Text("🍽️  " + dish.name.capitalized)
                        .fontWeight(.semibold)
                        .font(.headline)
                        .padding(.vertical, 6)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.secondary)
                }
                Divider()
            }
            .contentShape(Rectangle())
            .padding(.vertical, 3)
        }
    }
}

#Preview {
    IngredientDetailedView(
        ingredient: IngredientDetail(
            id: 1, category: "Vegetarian meat, fish, and egg alternatives",
            name: "Rice, whitsdadsadadsadadasdase, raw", purine_count: "5.9",
            tag: "low", description: "Beef kidne."),
        isFavorite: false
    )
    .environmentObject(UserStore())
    .environmentObject(FoodPurineStore())
}
