//
//  File.swift
//  
//
//  Created by Ayoub on 5/9/2023.
//

import Foundation
import SwiftUI

public struct RatingImages {
    let firstImage: String
    let secondImage: String
    let thirdImage: String
    let fourthImage: String
    let fifthImage: String
    
    public init(firstImage: String, secondImage: String, thirdImage: String, fourthImage: String, fifthImage: String) {
        self.firstImage = firstImage
        self.secondImage = secondImage
        self.thirdImage = thirdImage
        self.fourthImage = fourthImage
        self.fifthImage = fifthImage
    }
    
    func getImageByValue(value: Int) -> String {
        switch value {
        case 1: return firstImage
        case 2: return secondImage
        case 3: return thirdImage
        case 4: return fourthImage
        case 5: return fifthImage
        default: return firstImage
        }
    }
}

@available(iOS 15.0, *)
public struct RatingSlider<Content: View>: View {
    let width: CGFloat
    let height: CGFloat
    let images: RatingImages
    let didRate: (Int) -> Void
    let content: () -> Content
    private var rateItemList = [RateItem]()
    @State private var dragPoint = CGPoint(x: 0, y: 0)
    @State private var icon: String = ""
    @State private var shimmerStatus: Bool = true
    
    public init(width: CGFloat, height: CGFloat, images: RatingImages, content: @escaping () -> Content, didRate: @escaping (Int) -> Void) {
        self.width = width
        self.height = height
        self.images = images
        self.content = content
        self.didRate = didRate
        let range = width/4
        for i in 0...4 {
            var x: CGFloat = range * CGFloat(i)
            if x == 0 { x = height/2 }
            if x == width { x = width - height/2 }
            rateItemList.append(
                RateItem(
                    value: i,
                    icon: images.getImageByValue(value: i + 1),
                    minX: (range * CGFloat(i)) - range/2,
                    maxX: (range * CGFloat(i)) + range/2,
                    x: x
                )
            )
        }
    }
    
    public var body: some View {
        Capsule()
            .fill(.clear)
            .frame(width: width, height: height)
            .clipped()
            .overlay {
                ZStack {
                    content()
                    Shimmer(width: width, height: height, status: shimmerStatus)
                    Image(icon)
                        .resizable()
                        .frame(width: height - 5, height: height - 5)
                    .position(x: dragPoint.x, y: dragPoint.y)
                    //.animation(.easeInOut, value: dragPoint)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if shimmerStatus { shimmerStatus = false }
                                if value.location.x < width - height/2 && value.location.x > height/2 {
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
            .onAppear {
                self.dragPoint = CGPoint(x: height/2, y: height/2)
                self.icon = images.getImageByValue(value: 1)
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
