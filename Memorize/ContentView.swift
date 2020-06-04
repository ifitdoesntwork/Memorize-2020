//
//  ContentView.swift
//  Memorize
//
//  Created by Denis Avdeev on 04.06.2020.
//  Copyright © 2020 Denis Avdeev. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            ForEach(0..<4) { index in
                CardView(isFaseUp: true)
            }
        }
        .padding()
        .foregroundColor(.orange)
        .font(.largeTitle)
    }
}

struct CardView: View {
    
    private struct Constants {
        static let cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 3
    }
    
    var isFaseUp: Bool
    
    var body: some View {
        ZStack {
            if isFaseUp {
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .stroke(lineWidth: Constants.lineWidth)
                Text("👻")
            } else {
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .fill()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
