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

enum FoodItem: Identifiable {
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
    private let name: String
    var dishes = [DishDetail]()
    var ingredients = [IngredientDetail]()
    @Published var isLoading: Bool = true
    @Published var foods = [FoodItem]()
    @Published var searchText: String = ""
    @Published var selectedCategory: String = ""
    @Published var selectedTag: String = ""
    @Published var selectedType: String = ""

    // MARK: -Load Data
    private var ingredientDefaultKey: String {
        "FoodStore_Ingredient_" + name
    }
    
    private var dishDefaultKey: String {
        "FoodStore_Dish_" + name
    }
    
    init(named name: String, shouldLoadData: Bool = false) {
        self.name = name
        Task{
            print(isLoading)
            await loadData();
            print(isLoading)
        }
    }

    public func loadData() async {
        await MainActor.run { self.isLoading = true } // Show loading indicator

        await restoreFromUserDefaults()
        
        async let ingredientTask: () = loadIngredientsFromFile()
        async let dishTask: () = loadDishesFromFile()

        await (ingredientTask, dishTask)
        await combineFoods()
        await MainActor.run { self.isLoading = false } // Hide loading indicator

    }

    private func restoreFromUserDefaults() async {
        if let jsonData = UserDefaults.standard.data(forKey: ingredientDefaultKey),
           let decoded = try? JSONDecoder().decode([IngredientDetail].self, from: jsonData) {
            self.ingredients = decoded
        }

        if let jsonData = UserDefaults.standard.data(forKey: dishDefaultKey),
           let decoded = try? JSONDecoder().decode([DishDetail].self, from: jsonData) {
            self.dishes = decoded
        }
    }

    private func loadIngredientsFromFile() async {
        guard let url = Bundle.main.url(forResource: "purine_data", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let parsedIngredients = try? JSONDecoder().decode([IngredientDetail].self, from: data) else {
            print("Failed to load ingredients")
            return
        }

        self.ingredients = parsedIngredients
        storeDataToUserDefaults(data: parsedIngredients, key: ingredientDefaultKey)
    }

    private func loadDishesFromFile() async {
        guard let url = Bundle.main.url(forResource: "ingredients", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let rawDishes = try? JSONDecoder().decode([String: [String]].self, from: data) else {
            print("Failed to load dishes")
            return
        }

        // Create a lookup dictionary for fast ingredient matching
        let ingredientDict = Dictionary(uniqueKeysWithValues: ingredients.map { ($0.name, $0) })

        let parsedDishes = rawDishes.map { (dishName, ingredientIds) in
                // Find the ingredients by their IDs
            var dishIngredients = ingredientIds.compactMap { ingredientDict[$0] }
            
            return DishDetail(id: UUID(), name: dishName, ingredients: dishIngredients)
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
        self.foods = self.ingredients.map(FoodItem.ingredient) + self.dishes.map(FoodItem.dish)
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
                    return food.category.lowercased() == selectedCategory.lowercased()
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
    
    public func getAllCategories() -> [String]{
        if filteredFood.isEmpty{
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
    
    public func getAllType() -> [String]{
        if filteredFood.isEmpty{
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
    
    public func getAllPurineLevel() -> [String]{
        if filteredFood.isEmpty{
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
        // Custom sort order for purine levels
        let sortOrder: [String] = ["low", "medium", "high", "undefined"]
        
        // Sort using the custom order
        purineLevel.sort { (level1, level2) in
            if let index1 = sortOrder.firstIndex(of: level1), let index2 = sortOrder.firstIndex(of: level2) {
                return index1 < index2
            }
            return false
        }
        return purineLevel
    }
}
