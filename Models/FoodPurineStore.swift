//
//  Untitled.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/17.
//

import Foundation
import SwiftUI

struct IngredientDetail: Codable, Hashable, Identifiable {
    var id: Int
    var category: String
    var name: String
    var purine_count: String
    var tag: String
}

struct DishDetail: Codable, Hashable, Identifiable {
    var id: UUID
    var name: String
    var ingredients: [IngredientDetail]
}

enum FoodItem: Identifiable, Codable, Hashable {
    case dish(DishDetail)
    case ingredient(IngredientDetail)

    var id: UUID {
        switch self {
        case .dish(let dish):
            return dish.id
        case .ingredient:
            return UUID()
        }
    }
}

@MainActor
class FoodPurineStore: ObservableObject {
    var dishes = [DishDetail]()
    var ingredients = [IngredientDetail]()
    @Published var isLoading: Bool = true
    @Published var foods = [FoodItem]()
    @Published var searchText: String = ""
    @Published var selectedCategory: String = ""
    @Published var selectedTag: String = ""
    @Published var selectedType: String = ""

    @Published var topLowPurineByCategory: [String: [IngredientDetail]] = [:]

    // MARK: -Load Data
    private var ingredientDefaultKey: String = "FoodStore_Ingredient"

    private var dishDefaultKey: String = "FoodStore_Dish"

    private var topPurineDefaultKey: String = "FoodStore_TopPurine"

    init() {
        Task {
            self.isLoading = true
            let didRestorePurine = await restoreTopPurineFromUserDefaults()
            let didRestoreData = await restoreFromUserDefaults()
            print("Restored \(didRestoreData), \(didRestorePurine)")
            if !didRestoreData {
                await loadData()
            }

            if !didRestorePurine {
                computeLowPurineIngredients()
            }

            await combineFoods()
            self.isLoading = false
        }
    }

    public func loadData() async {
        await loadIngredientsFromFile()
        await loadDishesFromFile()
    }

    private func restoreFromUserDefaults() async -> Bool {
        var success = true

        if let jsonData = UserDefaults.standard.data(
            forKey: ingredientDefaultKey),
            let decoded = try? JSONDecoder().decode(
                [IngredientDetail].self, from: jsonData)
        {
            self.ingredients = decoded
        } else {
            success = false
        }

        if let jsonData = UserDefaults.standard.data(forKey: dishDefaultKey),
            let decoded = try? JSONDecoder().decode(
                [DishDetail].self, from: jsonData)
        {
            self.dishes = decoded
        } else {
            success = false
        }

        return success
    }

    private func computeLowPurineIngredients() {
        var categoryDict: [String: [IngredientDetail]] = [:]

        // Filter and group ingredients by category
        for ingredient in ingredients {
            // Trim any extra spaces and check if purine_count can be converted to a valid number
            let purineValue = ingredient.purine_count.trimmingCharacters(in: .whitespaces)
            
            // Ensure that the purine count is not "ND" and can be converted to a number
            if purineValue != "ND", purineValue != "0" {
                categoryDict[ingredient.category, default: []].append(ingredient)
            }
        }

        // Sort and pick top 10 for each category
        for (category, ingList) in categoryDict {
            let sortedList = ingList.sorted {
                Double($0.purine_count)! < Double($1.purine_count)!
            }
            topLowPurineByCategory[category] = Array(sortedList.prefix(10))
        }

        storeTopPurineToUserDefaults()
    }

    private func storeTopPurineToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(topLowPurineByCategory) {
            UserDefaults.standard.set(encoded, forKey: topPurineDefaultKey)
        }
    }

    private func restoreTopPurineFromUserDefaults() async -> Bool {
        if let jsonData = UserDefaults.standard.data(
            forKey: topPurineDefaultKey),
            let decoded = try? JSONDecoder().decode(
                [String: [IngredientDetail]].self, from: jsonData)
        {
            self.topLowPurineByCategory = decoded
            return true
        }
        return false
    }

    private func loadIngredientsFromFile() async {
        guard
            let url = Bundle.main.url(
                forResource: "purine_data", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let parsedIngredients = try? JSONDecoder().decode(
                [IngredientDetail].self, from: data)
        else {
            print("Failed to load ingredients")
            return
        }

        self.ingredients = parsedIngredients
        storeDataToUserDefaults(
            data: parsedIngredients, key: ingredientDefaultKey)
    }

    private func loadDishesFromFile() async {
        guard
            let url = Bundle.main.url(
                forResource: "ingredients", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let rawDishes = try? JSONDecoder().decode(
                [String: [String]].self, from: data)
        else {
            print("Failed to load dishes")
            return
        }

        // Create a lookup dictionary for fast ingredient matching
        let ingredientDict = Dictionary(
            uniqueKeysWithValues: ingredients.map { ($0.name, $0) })

        let parsedDishes = rawDishes.map { (dishName, ingredientIds) in
            // Find the ingredients by their IDs
            var dishIngredients = ingredientIds.compactMap {
                ingredientDict[$0]
            }
            dishIngredients.sort {
                if let purineA = Double($0.purine_count),
                    let purineB = Double($1.purine_count)
                {
                    return purineA < purineB
                }
                return false
            }
            return DishDetail(
                id: UUID(), name: dishName, ingredients: dishIngredients)
        }

        self.dishes = parsedDishes
        storeDataToUserDefaults(data: parsedDishes, key: dishDefaultKey)
    }

    private func storeDataToUserDefaults<T: Codable>(data: T, key: String) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    private func combineFoods() async {
        self.foods =
            self.ingredients.map(FoodItem.ingredient)
            + self.dishes.map(FoodItem.dish)
    }

    // MARK: - Intent
    var searchedFood: [FoodItem] {
        if searchText.isEmpty {
            return []
        }

        return foods.filter { item in
            switch item {
            case .ingredient(let food):
                return food.name.lowercased().contains(searchText.lowercased())
            case .dish(let dish):
                return dish.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var filteredFood: [FoodItem] {
        if searchText.isEmpty {
            return []
        }

        var result = searchedFood

        if !selectedCategory.isEmpty {
            result = result.filter { item in
                switch item {
                case .ingredient(let food):
                    return food.category.lowercased()
                        == selectedCategory.lowercased()
                case .dish:
                    return false
                }
            }
        }

        if !selectedTag.isEmpty {
            result = result.filter { item in
                switch item {
                case .ingredient(let food):
                    return food.tag.lowercased() == selectedTag.lowercased()
                case .dish:
                    return false
                }
            }
        }

        if !selectedType.isEmpty {
            result = result.filter { item in
                switch item {
                case .ingredient:
                    return selectedType == "🥕 Ingredients"
                case .dish:
                    return selectedType == "🍽️ Dishes"
                }
            }
        }
        return result
    }

    public func getLowPurineCategories() -> [String] {
        return Array(topLowPurineByCategory.keys).sorted()
    }

    public func getDishByName(_ name: String) -> DishDetail? {
        let modifiedString = name.replacingOccurrences(of: "_", with: " ")
            .lowercased()

        for item in foods {
            if case .dish(let dish) = item,
                dish.name.lowercased() == modifiedString
            {
                return dish
            }
        }
        return nil
    }
    
    public func getFoodById(_ id: Int) -> IngredientDetail? {
        for item in foods {
            if case .ingredient(let ingredient) = item,
               ingredient.id == id
            {
                return ingredient
            }
        }
        return nil
       }
    
    public func getAllCategories() -> [String] {
        if filteredFood.isEmpty {
            return []
        }
        var categoryNames: [String] = []

        for item in filteredFood {
            switch item {
            case .ingredient(let ingredient):
                categoryNames.append(ingredient.category)
            case .dish(_):
                continue
            }
        }
        categoryNames = Array(Set(categoryNames))
        categoryNames.sort()
        return categoryNames
    }

    public func getAllType() -> [String] {
        if filteredFood.isEmpty {
            return []
        }
        var type: [String] = []

        for item in filteredFood {
            switch item {
            case .ingredient:
                type.append("🥕 Ingredients")
            case .dish(_):
                type.append("🍽️ Dishes")
            }
        }
        type = Array(Set(type))
        return type
    }

    public func getAllPurineLevel() -> [String] {
        if filteredFood.isEmpty {
            return []
        }
        var purineLevel: [String] = []

        for item in filteredFood {
            switch item {
            case .ingredient(let ingredient):
                purineLevel.append(ingredient.tag)
            case .dish(_):
                continue
            }
        }
        purineLevel = Array(Set(purineLevel))
        return Helper.sortPurineLevel(purineLevel)
    }
}
