//
//  utils.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/17.
//

import SwiftUI

class Helper{
    // MARK: - UI Helper
    static let cateToColorMap: [String: Color] = [
        "Alcohol": .purple,
        "Beef (other than organs)": Color(hex: "#FF0000"),
        "Beef Organ Products": .brown,
        "Beverages": .blue,
        "Cereal grains and grain-based products": Color(hex: "#8B8000"),
        "Dairy and Eggs": .orange,
        "Finfish and shellfish": .teal,
        "Fruits": Color.init(hex: "#FF007F").opacity(0.9),
        "Lamb, veal, and game (other than organs)": Color(hex: "#FF0000"),
        "Lamb, veal, and game organ products": .brown,
        "Legumes and legume products": .green,
        "Nuts and seeds": .orange,
        "Pork (other than organs)": Color(hex: "#FF0000"),
        "Pork organ products": .brown,
        "Poultry (other than organs)": Color(hex: "#8B8000"),
        "Poultry organ products": .brown,
        "Sausages and luncheon meats": .gray,
        "Soups, sauces, and seasonings": .cyan,
        "Sweets": Color.init(hex: "#FF007F").opacity(0.9),
        "Vegetables": .green,
        "Vegetarian meat, fish, and egg alternatives": .mint,
    ]
    
    static func tagColor(tag: String) -> Color{
        if(tag == "low"){
            return Color.green
        } else if (tag == "medium"){
            return Color.orange
        } else {
            return Color.red
        }
    }
    
    static func tagImage(tag: String) -> some View{
        if(tag == "low"){
            return Image(systemName: "checkmark.circle.fill").foregroundStyle(tagColor(tag: "low"))
        } else if (tag == "medium"){
            return Image(systemName: "exclamationmark.circle.fill").foregroundStyle(tagColor(tag: "medium"))
        } else if (tag == "undefined"){
            return Image(systemName: "questionmark.circle.fill").foregroundStyle(Color.gray)
        }
        else {
            return Image(systemName: "xmark.circle.fill").foregroundStyle(tagColor(tag: "high"))
        }
    }
    
    static func ingredientCat(category: String) -> String{
        switch category {
        case "Alcohol":
            return "🍷"
        case "Beef (other than organs)":
            return "🥩"
        case "Beef Organ Products":
            return "🐮"
        case "Beverages":
            return "🥤"
        case "Cereal grains and grain-based products":
            return "🍞"
        case "Dairy and Eggs":
            return "🧀"
        case "Finfish and shellfish":
            return "🐟"
        case "Fruits":
            return "🍎"
        case "Lamb, veal, and game (other than organs)":
            return "🍖"
        case "Lamb, veal, and game organ products":
            return "🐑"
        case "Legumes and legume products":
            return "🥜"
        case "Nuts and seeds":
            return "🌰"
        case "Pork (other than organs)":
            return "🥓"
        case "Pork organ products":
            return "🐷"
        case "Poultry (other than organs)":
            return "🍗"
        case "Poultry organ products":
            return "🐔"
        case "Sausages and luncheon meats":
            return "🌭"
        case "Soups, sauces, and seasonings":
            return "🍜"
        case "Sweets":
            return "🍫"
        case "Vegetables":
            return "🥦"
        case "Vegetarian meat, fish, and egg alternatives":
            return "🥬"
        default:
            return "❓"
        }
    }
   
    static func ingredientCatDescription(category: String) -> String{
        switch category {
        case "Alcohol":
            return "Alcoholic drinks like beer and whiskey are high in purines, which can trigger gout attacks; gout patients should limit alcohol and opt for low-purine options."
        case "Beef (other than organs)":
            return "Beef, especially cuts like sirloin and brisket, can be high in purines, which may increase uric acid levels. Gout patients should limit beef intake."
        case "Beef Organ Products":
            return "Beef organ products like liver and kidney are very high in purines, which can worsen gout. Gout patients should avoid or limit these foods."
        case "Beverages":
            return "Beverages like green tea and fruit juice are low in purines and generally safe for gout patients. However, sugary fruit juices should be consumed in moderation."
        case "Cereal grains and grain-based products":
            return "Cereal grains and their products like white bread and pasta are low in purines, making them generally safe for gout patients. Whole grains are a healthier option."
        case "Dairy and Eggs":
            return "Dairy products like cheese and yogurt are low in purines, making them safe for gout patients. Eggs and milk are also good, low-purine choices."
        case "Finfish and shellfish":
            return "Finfish and shellfish like sardines, mackerel, and shrimp are high in purines, which can worsen gout. Gout patients should limit these foods."
        case "Fruits":
            return "Fruits like bananas, strawberries, and avocado are low in purines, making them safe for gout patients. Goji berries can also be enjoyed in moderation."
        case "Lamb, veal, and game (other than organs)":
            return "Lamb, veal, and mutton are moderate to high in purines, which can trigger gout attacks. Gout patients should limit their intake of these meats."
        case "Lamb, veal, and game organ products":
            return "Lamb organ products like heart and liver are high in purines, which can increase uric acid levels. Gout patients should avoid or limit these foods."
        case "Legumes and legume products":
            return "Legumes like beans, lentils, and soy products are moderate to high in purines, which can trigger gout. Gout patients should consume them in moderation."
        case "Nuts and seeds":
            return "Nuts and seeds like almonds, walnuts, and chia seeds are low in purines and safe for gout patients. They can be enjoyed in moderation."
        case "Pork (other than organs)":
            return "Pork cuts like roast, ribs, and tenderloin are moderate in purines and can trigger gout attacks. Gout patients should limit pork intake."
        case "Pork organ products":
            return "Pork organ products like liver, kidney, and heart are high in purines, which can worsen gout. Gout patients should avoid or limit these foods."
        case "Poultry (other than organs)":
            return "Poultry like chicken and turkey has moderate purine levels, which can trigger gout attacks. Gout patients should consume poultry in moderation."
        case "Poultry organ products":
            return "Poultry organ products like chicken liver and heart are high in purines, which can worsen gout. Gout patients should limit or avoid these foods."
        case "Sausages and luncheon meats":
            return "Sausages and luncheon meats like salami, prosciutto, and corned beef are high in purines, which can trigger gout. Gout patients should limit these foods."
        case "Soups, sauces, and seasonings":
            return "Soups, sauces, and seasonings like ketchup, curry, and soy sauce are generally low in purines but can be high in sodium. Gout patients should use them in moderation."
        case "Sweets":
            return "Chocolate and honey are low in purines, making them safe for gout patients. However, they should still be consumed in moderation due to sugar content."
        case "Vegetables":
            return "Most vegetables, like broccoli, carrots, and spinach, are low in purines and safe for gout patients. However, mushrooms and peas should be eaten in moderation."
        case "Vegetarian meat, fish, and egg alternatives":
            return "Vegetarian meat alternatives like tofu, veggie burgers, and soy-based products are low in purines and safe for gout patients. Moderation is key."
        default:
            return ""
        }
    }
    
    static func transformCate(_ category: String) -> String {
        if category.contains(", and") {
            return category.replacingOccurrences(of: ", and", with: " &")
        } else if category.contains("and")  {
            return category.replacingOccurrences(of: "and", with: "&")
        } else {
            return category
        }
    }
    
    // MARK: - utils
    static func formatStringToNearestThousandth(_ numberString: String) -> String {
        if numberString == "ND" {
            return "undefined"
        }
        if let number = Double(numberString) {
            let roundedNumber = round(number * 1000) / 1000
            return String(roundedNumber)
        }
        return numberString
    }
    
    static func sortPurineLevel(_ items: [String]) -> [String] {
        let sortOrder: [String] = ["low", "medium", "high", "undefined"]
        return items.sorted { (item1, item2) in
            if let index1 = sortOrder.firstIndex(of: item1),
               let index2 = sortOrder.firstIndex(of: item2) {
                return index1 < index2
            }
            return false
        }
    }
    
    static func sortIngredientsByPurineCount(_ ingredients: [IngredientDetail]) -> [IngredientDetail] {
        return ingredients.sorted { (ingredient1, ingredient2) in
            let purine1 = Double(ingredient1.purine_count) ?? Double.greatestFiniteMagnitude // Treat "ND" as highest
            let purine2 = Double(ingredient2.purine_count) ?? Double.greatestFiniteMagnitude
            return purine1 < purine2
        }
    }
    
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
