//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Denis Avdeev on 04.06.2020.
//  Copyright © 2020 Denis Avdeev. All rights reserved.
//

import Foundation

class EmojiMemoryGame: ObservableObject {
    
    typealias EmojiGame = MemoryGame<String>
    
    enum Color {
        case orange
    }
    
    private struct Theme {
        
        let name: String
        let emoji: [String]
        /// `nil` means random number of cards
        let numberOfPairsOfCards: Int?
        let color: Color
        
        static let halloween = Theme(
            name: "halloween",
            emoji: ["👻", "🎃", "🕷", "🧙‍♀️", "🦇"],
            numberOfPairsOfCards: 4,
            color: .orange
        )
    }
    
    private var theme: Theme = .halloween
    
    var color: Color {
        theme.color
    }
    
    @Published private var model = EmojiMemoryGame.createMemoryGame(theme: .halloween)

    private static func createMemoryGame(theme: Theme) -> EmojiGame {
        
        let emoji = theme.emoji.shuffled()
        
        let numberOfPairsOfCards = theme.numberOfPairsOfCards
            .map { min($0, emoji.count) }
            ?? Int.random(in: 2...emoji.count)
        
        return EmojiGame(numberOfPairsOfCards: numberOfPairsOfCards) { pairIndex in
            emoji[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    
    var cards: [EmojiGame.Card] {
        model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(card: EmojiGame.Card) {
        model.choose(card: card)
    }
}
