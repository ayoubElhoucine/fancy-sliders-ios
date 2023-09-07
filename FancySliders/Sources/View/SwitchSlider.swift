//
//  File.swift
//  
//
//  Created by Ayoub on 7/9/2023.
//

import Foundation
import SwiftUI


@available(iOS 15.0, *)
public struct SwitchSlider<Thumbnail: View>: View {
    let width: CGFloat
    let height: CGFloat
    let title: String
    let titleColor: Color
    let colorOn: Color
    let colorOff: Color
    let didComplete: (Bool) -> Void
    let thumbnail: () -> Thumbnail
    private var stepItemList = [StepItem]()
    @State private var dragPoint = CGPoint(x: 0, y: 0)
    @State private var shimmerStatus: Bool = true
    
    public init(width: CGFloat, height: CGFloat, title: String, titleColor: Color, colorOn: Color, colorOff: Color, thumbnail: @escaping () -> Thumbnail, didComplete: @escaping (Bool) -> Void) {
        self.width = width
        self.height = height
        self.title = title
        self.titleColor = titleColor
        self.colorOn = colorOn
        self.colorOff = colorOff
        self.thumbnail = thumbnail
        self.didComplete = didComplete
        for i in 0...1 {
            var x: CGFloat = width * CGFloat(i)
            if x == 0 { x = height/2 }
            if x == width { x = width - height/2 }
            stepItemList.append(
                StepItem(
                    value: i,
                    minX: (width * CGFloat(i)) - width/2,
                    maxX: (width * CGFloat(i)) + width/2,
                    x: x
                )
            )
        }
    }
    
    public var body: some View {
        Capsule()
            .fill(.clear)
            .frame(width: width, height: height)
            .overlay {
                Capsule().fill(colorOff)
                HStack(spacing: 0) {
                    Capsule().fill(colorOn)
                        .frame(width: dragPoint.x + height/2)
                    Spacer(minLength: 0)
                }
                Text(title).foregroundColor(titleColor).fontWeight(.semibold)
                Shimmer(width: width, height: height, status: shimmerStatus)
                thumbnail()
                    .frame(width: height, height: height)
                    .position(x: dragPoint.x, y: dragPoint.y)
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
                                    if let value = item?.boolValue { self.didComplete(value) }
                                }
                            }
                    )
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
        
        var boolValue: Bool {
            get {
                if value == 0 {
                    return false
                } else {
                    return true
                }
            }
        }
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
