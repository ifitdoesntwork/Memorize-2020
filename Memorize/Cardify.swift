//
//  Cardify.swift
//  Memorize
//
//  Created by Denis Avdeev on 13.06.2020.
//  Copyright © 2020 Denis Avdeev. All rights reserved.
//

import SwiftUI

struct Cardify: ViewModifier {
    
    struct Colors {
        let primary: SwiftUI.Color
        let secondary: SwiftUI.Color
    }
    
    let isFaceUp: Bool
    let colors: Colors
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            self.body(for: geometry.size, content: content)
        }
    }
    
    private func body(for size: CGSize, content: Content) -> some View {
        ZStack {
            if isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: edgeLineWidth)
                    .foregroundColor(colors.primary)
                content
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(radialGradient(for: size))
            }
        }
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
