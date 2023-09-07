//
//  ContentView.swift
//  iOS Example
//
//  Created by Ayoub on 5/9/2023.
//

import Foundation
import SwiftUI
import FancySliders


//struct SwiftUIxxPROJECTxNAMExx: UIViewRepresentable {
//    func makeUIView(context: Context) -> UIView {
//        return UIKitView()
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//    }
//}

struct ContentView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            RatingSlider (
                width: UIScreen.main.bounds.width - 32,
                height: 58,
                images: RatingImages(firstImage: "emoji-1", secondImage: "emoji-2", thirdImage: "emoji-3", fourthImage: "emoji-4", fifthImage: "emoji-5"),
                content: {
                    ZStack {
                        Capsule().fill(.yellow)
                        Text("Rate your experience!")
                            .foregroundColor(.white)
                    }
                },
                didRate: { value in
                    print("rate value: \(value)")
                }
            )
            
            Slider(width: UIScreen.main.bounds.width - 32, height: 60, stepCount: 3) {
                Circle().fill(.red)
            } content: {
                Capsule().fill(.cyan)
            } didComplete: { value in
                print("step value: \(value)")
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
