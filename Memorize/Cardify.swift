//
//  Cardify.swift
//  Memorize
//
//  Created by Denis Avdeev on 13.06.2020.
//  Copyright © 2020 Denis Avdeev. All rights reserved.
//

import SwiftUI

struct Cardify: AnimatableModifier {
    
    struct Colors {
        let primary: SwiftUI.Color
        let secondary: SwiftUI.Color
    }
    
    private var rotation: Double
    private let colors: Colors
    
    init(isFaceUp: Bool, colors: Colors) {
        rotation = isFaceUp ? 0 : 180
        self.colors = colors
    }
    
    private var isFaceUp: Bool {
        rotation < 90
    }
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            self.body(for: geometry.size, content: content)
        }
    }
    
    private func body(for size: CGSize, content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: edgeLineWidth)
                    .foregroundColor(colors.primary)
                content
            }
                .opacity(isFaceUp ? 1 : 0)
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(radialGradient(for: size))
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0))
    }
    
    private func radialGradient(for size: CGSize) -> RadialGradient {
        .init(
            gradient: .init(colors: [colors.primary, colors.secondary]),
            center: .center,
            startRadius: gradientStartRadius,
            endRadius: max(size.width, size.height)
        )
    }
    
    // MARK: - Drawing Constants
    
    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 3
    private let gradientStartRadius: CGFloat = 30
}

extension View {
    func cardify(isFaceUp: Bool, colors: Cardify.Colors) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, colors: colors))
    }
}

struct Cardify_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
            .cardify(
                isFaceUp: true,
                colors: .init(primary: .orange, secondary: .yellow)
            )
            .padding()
    }
}
