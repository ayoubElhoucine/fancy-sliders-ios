//
//  File.swift
//  
//
//  Created by Ayoub on 7/9/2023.
//

import Foundation
import SwiftUI


@available(iOS 15.0, *)
public struct Slider<Content: View, Thumbnail: View>: View {
    let width: CGFloat
    let height: CGFloat
    let stepCount: Int
    let didComplete: (Int) -> Void
    let content: () -> Content
    let thumbnail: () -> Thumbnail
    private var stepItemList = [StepItem]()
    @State private var dragPoint = CGPoint(x: 0, y: 0)
    @State private var shimmerStatus: Bool = true
    
    public init(width: CGFloat, height: CGFloat, stepCount: Int, thumbnail: @escaping () -> Thumbnail, content: @escaping () -> Content, didComplete: @escaping (Int) -> Void) {
        self.width = width
        self.height = height
        self.stepCount = stepCount
        self.content = content
        self.thumbnail = thumbnail
        self.didComplete = didComplete
        let range = width/CGFloat(stepCount - 1)
        for i in 0...stepCount - 1 {
            var x: CGFloat = range * CGFloat(i)
            if x == 0 { x = height/2 }
            if x == width { x = width - height/2 }
            stepItemList.append(
                StepItem(
                    value: i,
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
                    thumbnail()
                        .frame(width: height - 5, height: height - 5)
                        .position(x: dragPoint.x, y: dragPoint.y)
                        //.animation(.easeInOut, value: dragPoint)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if shimmerStatus { shimmerStatus = false }
                                    if value.location.x < width - height/2 && value.location.x > height/2 {
                                        dragPoint.x = value.location.x
                                    }
                                }
                                .onEnded { value in
                                    withAnimation {
                                        let item = getStepItem(value: value.location.x)
                                        if let x = item?.x { self.dragPoint.x = x }
                                        if let value = item?.value { self.didComplete(value) }
                                    }
                                }
                        )
                }
            }
            .onAppear {
                self.dragPoint = CGPoint(x: height/2, y: height/2)
            }
    }
    
    private struct StepItem {
        let value: Int
        let minX: CGFloat
        let maxX: CGFloat
        let x: CGFloat
    }
    
    private func getStepItem(value: CGFloat) -> StepItem? {
        for item in stepItemList {
            if value > item.minX && value < item.maxX {
                return item
            }
        }
        return nil
    }
}
