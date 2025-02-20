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

    // MARK: User Intent
    func addFavDish(_ item: DishDetail) {
        userFavDish.append(item)
    }
    
    func addFavIngredient(_ item: IngredientDetail) {
        userFavIngredient.append(item)
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
    
    func isDishFav(_ item: DishDetail) -> Bool{
        return userFavDish.contains(item)
    }
    
    func isIngredientFav(_ item: IngredientDetail) -> Bool{
        return userFavIngredient.contains(item)
    }

    //    func filterUserPreferences(category: String? = nil, tag: String? = nil, isDish: Bool? = nil) -> [FoodItem] {
    //        return userPreferences.filter { item in
    //            switch item {
    //            case .dish(let dish):
    //                return (isDish ?? true) && (category == nil || dish.name == category) && (tag == nil)
    //            case .ingredient(let ingredient):
    //                return (isDish ?? false) && (category == nil || ingredient.category == category) && (tag == nil || ingredient.tag == tag)
    //            }
    //        }
    //    }

    func addRecentSearch(_ search: FoodItem) {
        if let index = recentSearches.firstIndex(of: search) {
            recentSearches.remove(at: index)
        }

        recentSearches.insert(search, at: 0)

        if recentSearches.count > 10 {
            recentSearches.removeLast()
        }
    }
}
