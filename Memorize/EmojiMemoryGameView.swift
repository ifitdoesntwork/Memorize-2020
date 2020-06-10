//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Denis Avdeev on 04.06.2020.
//  Copyright © 2020 Denis Avdeev. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            HStack {
                Text(self.viewModel.name)
                Spacer()
                Button("New Game") {
                    self.viewModel.restart()
                }
            }
            .padding(.horizontal)
            
            Grid(viewModel.cards) { card in
                CardView(card: card, colors: self.viewModel.color.uiColors)
                    .padding(5)
                    .onTapGesture {
                        self.viewModel.choose(card: card)
                    }
            }
            
            Text("Score: \(viewModel.score)")
        }
        .padding()
        .foregroundColor(viewModel.color.uiColors.primary)
    }
}

struct CardView: View {
    
    let card: MemoryGame<String>.Card
    fileprivate let colors: EmojiMemoryGame.Color.UIColors
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    private func body(for size: CGSize) -> some View {
        ZStack {
            if self.card.isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: edgeLineWidth)
                Text(self.card.content)
            } else {
                if !card.isMatched {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(RadialGradient(
                            gradient: .init(colors: [colors.primary, colors.secondary]),
                            center: .center,
                            startRadius: gradientStartRadius,
                            endRadius: max(size.width, size.height)
                        ))
                }
            }
        }
        .font(.system(size: fontSize(for: size)))
    }
    
    // MARK: - Drawing Constants
    
    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 3
    private let gradientStartRadius: CGFloat = 30
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
}

private extension EmojiMemoryGame.Color {
    
    struct UIColors {
        let primary: SwiftUI.Color
        let secondary: SwiftUI.Color
    }
    
    var uiColors: UIColors {
        switch self {
        case .orange:
            return .init(primary: .orange, secondary: .yellow)
        case .red:
            return .init(primary: .red, secondary: .orange)
        case .yellow:
            return .init(primary: .yellow, secondary: .white)
        case .green:
            return .init(primary: .green, secondary: .yellow)
        case .cyan:
            return .init(primary: .blue, secondary: .pink)
        case .blue:
            return .init(primary: .blue, secondary: .purple)
        case .magenta:
            return .init(primary: .purple, secondary: .pink)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
