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
