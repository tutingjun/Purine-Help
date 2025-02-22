//
//  SwiftUIView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/22.
//

import SwiftUI

struct TopView: View {
    @EnvironmentObject var food: FoodPurineStore
    @EnvironmentObject var user: UserStore

    @State private var selectedCategory: String? = nil

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                List {
                    Section(
                        header: Text("Categories")
                            .font(.subheadline)
                    ) {

                        ForEach(food.getLowPurineCategories(), id: \.self) {
                            category in
                            NavigationLink {
                                TopIngredientList(
                                    categoryList: food.topLowPurineByCategory[category]!, category: category
                                )
                                .environmentObject(user)
                            } label: {
                                HStack(spacing: 15) {
                                    Text(
                                        Helper.ingredientCat(category: category)
                                    )
                                    .font(.system(size: 24))
                                    Text(Helper.transformCate(category).capitalized)
                                        .font(.system(size: 18))
                                        .lineSpacing(5)
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .padding(.vertical, 3)
                            }
                        }
                    }
                }
                .navigationTitle("Top Ingredients")
            }
        }
    }
}

#Preview {
    TopView()
        .environmentObject(FoodPurineStore())
        .environmentObject(UserStore())
}
