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
                    .animation(.none)
                Spacer()
                Button("New Game") {
                    withAnimation(.easeInOut) {
                        self.viewModel.restart()
                    }
                }
            }
            .padding(.horizontal)
            
            Grid(viewModel.cards) { card in
                CardView(card: card, colors: self.viewModel.color.uiColors)
                    .padding(5)
                    .onTapGesture {
                        withAnimation(.linear(duration: 0.75)) {
                            self.viewModel.choose(card: card)
                        }
                    }
            }
            
            Text("Score: \(viewModel.score)")
                .animation(.none)
        }
        .padding()
        .foregroundColor(viewModel.color.uiColors.primary)
    }
}

struct CardView: View {
    
    let card: MemoryGame<String>.Card
    let colors: Cardify.Colors
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @ViewBuilder private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                pie
                emoji
                    .font(.system(size: fontSize(for: size)))
            }
            .cardify(isFaceUp: card.isFaceUp, colors: colors)
            .transition(.scale)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    private var pie: some View {
        Group {
            if card.isConsumingBonusTime {
                Pie(
                    startAngle: .degrees(0 - 90),
                    endAngle: .degrees(-animatedBonusRemaining * 360 - 90)
                )
                .onAppear {
                    self.startBonusTimeAnimation()
                }
            } else {
                Pie(
                    startAngle: .degrees(0 - 90),
                    endAngle: .degrees(-card.bonusRemaining * 360 - 90)
                )
            }
        }
        .padding(piePadding)
        .opacity(pieOpacity)
        .transition(.identity)
    }
    
    private var emoji: some View {
        Text(card.content)
            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
            .animation(
                card.isMatched
                    ? Animation.linear(duration: 1)
                        .repeatForever(autoreverses: false)
                    : .default
            )
    }
    
    // MARK: - Drawing Constants
    
    private let piePadding: CGFloat = 5
    private let pieOpacity = 0.4
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
}

private extension EmojiMemoryGame.Color {
    
    var uiColors: Cardify.Colors {
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
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
