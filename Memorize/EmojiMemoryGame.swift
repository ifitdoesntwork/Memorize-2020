//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Denis Avdeev on 04.06.2020.
//  Copyright © 2020 Denis Avdeev. All rights reserved.
//

import Foundation

class EmojiMemoryGame {
    
    typealias EmojiGame = MemoryGame<String>
    
    private var model = EmojiMemoryGame.createMemoryGame()
    
    private static func createMemoryGame() -> EmojiGame {
        let emojis = ["👻", "🎃", "🕷", "🧙‍♀️", "🦇", "1️⃣", "2️⃣", "3️⃣", "4️⃣", "5️⃣"]
            .shuffled()
        return EmojiGame(numberOfPairsOfCards: Int.random(in: 2...5)) { pairIndex in
            emojis[pairIndex]
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
