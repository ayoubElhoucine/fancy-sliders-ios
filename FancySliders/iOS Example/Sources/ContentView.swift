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
        VStack(alignment: .center) {
            RatingView (
                width: UIScreen.main.bounds.width - 32,
                height: 58,
                images: RatingImages(firstImage: "emoji-1", secondImage: "emoji-2", thirdImage: "emoji-3", fourthImage: "emoji-4", fifthImage: "emoji-5"),
                content: {
                    Capsule()
                        .fill(.yellow)
//                        .stroke(Color.yellow, lineWidth: 1.5)
                },
                didRate: { value in
                    print("value === \(value)")
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
