//
//  File.swift
//  
//
//  Created by Ayoub on 5/9/2023.
//

import Foundation
import SwiftUI


@available(iOS 15.0, *)
public struct RatingView: View {
    let width: CGFloat
    let didRate: (Int) -> Void
    private static let height: CGFloat = 58
    private var rateItemList = [RateItem]()
    @State private var dragPoint = CGPoint(x: height/2, y: height/2)
    @State private var icon: String = "emoji-1"
    
    public init(width: CGFloat, didRate: @escaping (Int) -> Void) {
        self.width = width
        self.didRate = didRate
        let range = width/4
        for i in 0...4 {
            var x: CGFloat = range * CGFloat(i)
            if x == 0 { x = RatingView.height/2 }
            if x == width { x = width - RatingView.height/2 }
            rateItemList.append(
                RateItem(
                    value: i,
                    icon: "emoji-\(i + 1)",
                    minX: (range * CGFloat(i)) - range/2,
                    maxX: (range * CGFloat(i)) + range/2,
                    x: x
                )
            )
        }
    }
    
    public var body: some View {
        Capsule()
            .fill(.yellow)
            .frame(width: width, height: RatingView.height)
            .overlay {
                Image(icon)
                    .resizable()
                    .frame(width: 55, height: 55)
                .position(x: dragPoint.x, y: dragPoint.y)
                //.animation(.easeInOut, value: dragPoint)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.location.x < width - RatingView.height/2 && value.location.x > RatingView.height/2 {
                                dragPoint.x = value.location.x
                                DispatchQueue.main.async {
                                    if let icon = getRateItem(value: value.location.x)?.icon { self.icon = icon }
                                }
                            }
                        }
                        .onEnded { value in
                            withAnimation {
                                let rateItem = getRateItem(value: value.location.x)
                                if let x = rateItem?.x { self.dragPoint.x = x }
                                if let icon = rateItem?.icon { self.icon = icon }
                                if let value = rateItem?.value { self.didRate(value) }
                            }
                        }
                )
            }
    }
    
    private struct RateItem {
        let value: Int
        let icon: String
        let minX: CGFloat
        let maxX: CGFloat
        let x: CGFloat
    }
    
    private func getRateItem(value: CGFloat) -> RateItem?{
        for item in rateItemList {
            if value > item.minX && value < item.maxX {
                return item
            }
        }
        return nil
    }
}
