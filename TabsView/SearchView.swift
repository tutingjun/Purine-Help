import SwiftUI

struct SearchView: View {
    @EnvironmentObject var store: FoodPurineStore

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 2) {
                VStack(){
                    Text("最近搜索")
                    HStack{
                        Text("Recent")
                    }
                }
                .padding(.horizontal)
                if !store.filteredFood.isEmpty {
                    FilterGroup()
                        .padding(.vertical, 5)
                }
                List {
                    ForEach(store.filteredFood) { foodItem in
                        switch foodItem {
                        case .ingredient(let ingredient):
                            IngredientRow(ingredient)
                        case .dish(let dish):
                            DishRow(dish)
                        }
                    }
                }
                .listStyle(.inset)
                .navigationTitle("Search for Food")
                .searchable(
                    text: $store.searchText,
                    placement: .navigationBarDrawer(displayMode: .always))
            }

        }

    }
    
    @ViewBuilder
    private func IngredientRow(_ ingredient: IngredientDetail) -> some View {
        NavigationLink {
            IngredientDetailedView(ingredient: ingredient)
        } label: {
            VStack(alignment: .leading, spacing: 3) {
                Text(
                    Helper.ingredientCat(
                        category: ingredient.category) + " "
                        + ingredient.name
                )
                .fontWeight(.semibold)
                .font(.headline)
                HStack(spacing: 1) {
                    Text("Purine Level: ")
                    Text(ingredient.tag.capitalized)
                        .foregroundStyle(
                            Helper.tagColor(
                                tag: ingredient.tag)
                        )
                        .fontWeight(.medium)
                }
                .font(.system(size: 14))
            }
        }
    }

    @ViewBuilder
    private func DishRow(_ dish: DishDetail) -> some View {
        NavigationLink {
            DishDetailedView(dish: dish)
        } label: {
            Text("🍽️ " + dish.name.capitalized)
                .fontWeight(.semibold)
                .font(.headline)
                .padding(.vertical, 6)
        }
    }
    
    @ViewBuilder
    private func FilterGroup() -> some View {
        HStack {
            TypeFilter()
            CategoryFilter()
            LevelFilter()
            Spacer()
        }
        .padding(.leading)
    }

    @ViewBuilder
    private func TypeFilter() -> some View {
        Menu {
            ForEach(store.getAllType(), id: \.self) { type in
                Button(action: {
                    if store.selectedType == type {
                        store.selectedType = ""
                    } else {
                        store.selectedType = type
                    }
                }) {
                    if store.selectedType == type {
                        Label(type, systemImage: "checkmark")
                    } else {
                        Text(type)
                    }

                }
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                Text("Type")
            }
        }
    }

    @ViewBuilder
    private func CategoryFilter() -> some View {
        Menu {
            ForEach(store.getAllCategories(), id: \.self) { category in
                Button(action: {
                    if store.selectedCategory == category {
                        store.selectedCategory = ""
                    } else {
                        store.selectedCategory = category
                    }
                }) {
                    if store.selectedCategory == category {
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
            ForEach(store.getAllPurineLevel(), id: \.self) { level in
                Button(action: {
                    if store.selectedTag == level {
                        store.selectedTag = ""
                    } else {
                        store.selectedTag = level
                    }
                }) {
                    if store.selectedTag == level {
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
