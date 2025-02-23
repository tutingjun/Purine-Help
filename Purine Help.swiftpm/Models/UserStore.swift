//
//  UserStore.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/19.
//

import SwiftUI

class UserStore: ObservableObject {
    @Published var userFavDish: [DishDetail] {
        didSet {
            if let encoded = try? JSONEncoder().encode(self.userFavDish) {
                UserDefaults.standard.set(encoded, forKey: "userFavDish")
            }
        }
    }

    @Published var userFavIngredient: [IngredientDetail] {
        didSet {
            if let encoded = try? JSONEncoder().encode(self.userFavIngredient) {
                UserDefaults.standard.set(encoded, forKey: "userFavIngredient")
            }
        }
    }

    @Published var recentSearches: [FoodItem] {
        didSet {
            if let encoded = try? JSONEncoder().encode(self.recentSearches) {
                UserDefaults.standard.set(encoded, forKey: "recentSearches")
            }
        }
    }

    init() {
        if let savedData = UserDefaults.standard.data(
            forKey: "userFavDish"),
            let decodedData = try? JSONDecoder().decode(
                [DishDetail].self, from: savedData)
        {
            self.userFavDish = decodedData
        } else {
            self.userFavDish = []
        }

        if let savedData = UserDefaults.standard.data(
            forKey: "userFavIngredient"),
            let decodedData = try? JSONDecoder().decode(
                [IngredientDetail].self, from: savedData)
        {
            self.userFavIngredient = decodedData
        } else {
            self.userFavIngredient = []
        }

        if let savedData = UserDefaults.standard.data(forKey: "recentSearches"),
            let decodedData = try? JSONDecoder().decode(
                [FoodItem].self, from: savedData)
        {
            self.recentSearches = decodedData
        } else {
            self.recentSearches = []
        }
    }

    // MARK: - User Intent
    @Published var searchText: String = ""
    @Published var selectedCategory: String = ""
    @Published var selectedTag: String = ""

    var searchedFood: [IngredientDetail] {
        if searchText.isEmpty {
            return userFavIngredient
        }

        return userFavIngredient.filter { ingredient in
            return ingredient.name.lowercased().contains(
                searchText.lowercased())
        }
    }
    
    var filteredFood: [IngredientDetail] {
        var result = searchedFood
        
        if !selectedCategory.isEmpty {
            result = result.filter { item in
                item.category.lowercased() == selectedCategory.lowercased()
                }
            }
        
        if !selectedTag.isEmpty {
            result = result.filter { item in
                item.tag.lowercased() == selectedTag.lowercased()
               
            }
        }
        return Helper.sortIngredientsByPurineCount(result)
    }
    
    public func getAllCategories() -> [String]{
        if filteredFood.isEmpty{
            return []
        }
        var categoryNames: [String] = []

        for item in filteredFood {
            categoryNames.append(item.category)
        }
        
        categoryNames = Array(Set(categoryNames))
        categoryNames.sort()
        return categoryNames
    }
    
    public func getAllPurineLevel() -> [String]{
        if filteredFood.isEmpty{
            return []
        }
        var purineLevel: [String] = []

        for item in filteredFood {
            purineLevel.append(item.tag)
        }
        purineLevel = Array(Set(purineLevel))
        return Helper.sortPurineLevel(purineLevel)
    }
    
    func addFavDish(_ item: DishDetail) {
        userFavDish.insert(item, at: 0)
    }

    func addFavIngredient(_ item: IngredientDetail) {
        userFavIngredient.insert(item, at: 0)
    }

    func removeFavDish(_ item: DishDetail) {
        userFavDish.removeAll { $0 == item }
    }

    func removeFavIngredient(_ item: IngredientDetail) {
        userFavIngredient.removeAll { $0 == item }
    }

    func removeFavDish(at offsets: IndexSet) {
        userFavDish.remove(atOffsets: offsets)
    }
    
    func removeFavIngredient(at offsets: IndexSet) {
        let itemsToRemove = offsets.map { filteredFood[$0] }
        userFavIngredient.removeAll { itemsToRemove.contains($0) }
    }

    func isDishFav(_ item: DishDetail) -> Bool {
        return userFavDish.contains(item)
    }

    func isIngredientFav(_ item: IngredientDetail) -> Bool {
        return userFavIngredient.contains(item)
    }

    func addRecentSearch(_ search: FoodItem) {
        if let index = recentSearches.firstIndex(of: search) {
            recentSearches.remove(at: index)
        }

        recentSearches.insert(search, at: 0)

        if recentSearches.count > 5 {
            recentSearches.removeLast()
        }
    }
}
