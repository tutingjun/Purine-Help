import SwiftUI
import WrappingHStack

struct SearchView: View {
    @EnvironmentObject var store: FoodPurineStore
    @EnvironmentObject var user: UserStore

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 2) {
                // MARK: Recent Search
                if !user.recentSearches.isEmpty && store.searchText.isEmpty {
                    VStack(spacing: 4){
                        HStack{
                            Text("Recent Search")
                                .font(.headline)
                            Spacer()
                            Button{
                                user.recentSearches = []
                            } label: {
                                Text("Clear")
                            }
                        }
                        Divider()
                        WrappingHStack(user.recentSearches, id: \.self){item in
                            switch item {
                            case .ingredient(let ingredient):
                                NavigationLink{
                                    IngredientDetailedView(
                                        ingredient: ingredient,
                                        isFavorite: user.isIngredientFav(ingredient))
                                        .environmentObject(user)
                                        .environmentObject(store)
                                } label: {
                                    RecentSearchCapsule(name: ingredient.name.capitalized)
                                }
                                .buttonStyle(PlainButtonStyle())
                            case .dish(let dish):
                                NavigationLink{
                                    DishDetailedView(dish: dish, isFavorite: user.isDishFav(dish))
                                        .environmentObject(user)
                                        .environmentObject(store)
                                } label: {
                                    RecentSearchCapsule(name: dish.name.capitalized)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            Spacer()
                        }
                        .padding(.vertical, 5)
                    }
                    .padding(.horizontal)
                }
                
                // MARK: Filter search result
                if !store.filteredFood.isEmpty {
                    FilterGroup()
                        .padding(.vertical, 5)
                }
                
                // MARK: Not found
                if store.filteredFood.isEmpty && !store.searchText.isEmpty {
                    HStack{
                        Spacer()
                        VStack(alignment: .center, spacing: 10){
                            Text("No Results. 😥")
                            Text("Please try a different search.")
                        }
                        .font(.system(size: 18))
                        Spacer()
                    }
                    .padding()
                    
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
    private func RecentSearchCapsule(name: String) -> some View {
        Text(name)
            .padding(5)
            .padding(.horizontal, 10)
            .background(Color.secondary.opacity(0.2))
            .clipShape(Capsule())
            .padding(.bottom, 5)
    }
    
    @ViewBuilder
    private func IngredientRow(_ ingredient: IngredientDetail) -> some View {
        NavigationLink {
            IngredientDetailedView(
                ingredient: ingredient,
                isFavorite: user.isIngredientFav(ingredient))
                .environmentObject(user)
                .environmentObject(store)
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
            DishDetailedView(dish: dish, isFavorite: user.isDishFav(dish))
                .environmentObject(user)
                .environmentObject(store)
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
