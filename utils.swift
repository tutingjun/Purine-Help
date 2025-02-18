//
//  utils.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/17.
//

import SwiftUI

class Helper{
    // MARK: - UI Helper
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
            return Image(systemName: "exclamationmark.triangle.fill").foregroundStyle(tagColor(tag: "medium"))
        } else {
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
        if let number = Double(numberString) {
            let roundedNumber = round(number * 1000) / 1000
            return String(roundedNumber)
        }
        return numberString
    }
    
}
