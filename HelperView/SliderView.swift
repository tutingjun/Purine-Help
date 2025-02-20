//
//  SwiftUIView.swift
//  Purine Help
//
//  Created by 涂庭鋆 on 2025/2/19.
//

import SwiftUI

struct SliderView: View {
    let minValue: Double = 0
    let midValue1: Double = 100
    let midValue2: Double = 200
    let maxValue: Double = 400
    let currentValue: Double
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geometry in
                let width = geometry.size.width
                let relativePosition =
                CGFloat(
                    (min(currentValue, maxValue) - minValue)
                    / (maxValue - minValue))
                * width
                let range1 =
                CGFloat(
                    (midValue1 - minValue) / (maxValue - minValue))
                * width
                let range2 =
                CGFloat(
                    (midValue2 - midValue1) / (maxValue - minValue))
                * width
                let range3 =
                CGFloat(
                    (maxValue - midValue2) / (maxValue - minValue))
                * width
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 2) {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: range1, height: 8)
                            .foregroundColor(Color.green.opacity(0.7))
                        
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: range2, height: 8)
                            .foregroundColor(Color.orange.opacity(0.7))
                        
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: range3, height: 8)
                            .foregroundColor(Color.red.opacity(0.7))
                    }
                    
                    HStack(spacing: 0) {
                        Text("\(Int(minValue))")
                        Spacer()
                            .frame(width: range1 - 20, height: 8)
                        Text("\(Int(midValue1))")
                        Spacer()
                            .frame(width: range2 - 20, height: 8)
                        Text("\(Int(midValue2))")
                    }
                    .font(.footnote)
                    .foregroundColor(.gray)
                }
                
                Triangle()
                    .fill(getTriangleColor(relativePosition, range1: range1, range2: range2, range3: range3))
                    .frame(width: 12, height: 10)
                    .position(x: relativePosition, y: -5)
            }
        }
        
    }
    
    func getTriangleColor(_ relativePosition: Double, range1: Double, range2: Double, range3: Double) -> Color{
        if( 0 <= relativePosition && relativePosition < range1){
            return Color.green.opacity(0.7)
        } else if (range1 <= relativePosition && relativePosition <= range1 + range2){
            return Color.orange.opacity(0.7)
        } else {
            return Color.red.opacity(0.7)
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    SliderView(currentValue: 100)
}
