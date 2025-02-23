//
//  SwiftUIView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/21.
//

import SwiftUI

struct FavoriteIngredientFilter: View {
    @EnvironmentObject var user: UserStore
    @EnvironmentObject var food: FoodPurineStore
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing: 2) {
                FilterGroup()
                    .padding(.vertical, 5)
                List{
                    ForEach(user.filteredFood){ingredient in
                        IngredientRow(ingredient)
                    }
                    .onDelete(perform: user.removeFavIngredient(at:))
                }
                .listStyle(.inset)
            }
            .navigationTitle("Favorite Ingredients")
            .searchable(
                text: $user.searchText,
                placement: .navigationBarDrawer(displayMode: .always))
            .onAppear{
                user.searchText = ""
                user.selectedCategory = ""
                user.selectedTag = ""
            }
        }
    }
    
    @ViewBuilder
    private func IngredientRow(_ ingredient: IngredientDetail) -> some View {
        NavigationLink {
            IngredientDetailedView(ingredient: ingredient,
                                   isFavorite: user.isIngredientFav(ingredient))
                .environmentObject(user)
                .environmentObject(food)
        } label: {
            HStack(alignment:.center, spacing: 10) {
                Text(
                    Helper.ingredientCat(
                        category: ingredient.category)
                )
                .font(.system(size: 25, weight: .semibold))
                
                VStack(alignment: .leading, spacing: 2){
                    Text(
                        ingredient.name
                    )
                    .fontWeight(.semibold)
                    .font(.headline)
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
        }
    }

    
    
    @ViewBuilder
    private func FilterGroup() -> some View {
        HStack {
            CategoryFilter()
            LevelFilter()
            Spacer()
            EditButton()
        }
        .padding(.horizontal)
    }


    @ViewBuilder
    private func CategoryFilter() -> some View {
        Menu {
            ForEach(user.getAllCategories(), id: \.self) { category in
                Button(action: {
                    if user.selectedCategory == category {
                        user.selectedCategory = ""
                    } else {
                        user.selectedCategory = category
                    }
                }) {
                    if user.selectedCategory == category {
                        Label(
                            Helper.ingredientCat(category: category) + " "
                                + category, systemImage: "checkmark")
                    } else {
                        Text(
                            Helper.ingredientCat(category: category) + " "
                                + category)
                    }

                }
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                Text("Category")
            }
        }
    }

    @ViewBuilder
    private func LevelFilter() -> some View {
        Menu {
            ForEach(user.getAllPurineLevel(), id: \.self) { level in
                Button(action: {
                    if user.selectedTag == level {
                        user.selectedTag = ""
                    } else {
                        user.selectedTag = level
                    }
                }) {
                    if user.selectedTag == level {
                        Label(level.capitalized, systemImage: "checkmark")
                    } else {
                        Text(level.capitalized)
                    }
                }
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                Text("Purine Level")
            }
        }
    }
    
}

#Preview {
    FavoriteIngredientFilter()
        .environmentObject(UserStore())
        .environmentObject(FoodPurineStore())
}
