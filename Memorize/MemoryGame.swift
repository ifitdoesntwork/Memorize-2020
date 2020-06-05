//
//  MemoryGame.swift
//  Memorize
//
//  Created by Denis Avdeev on 04.06.2020.
//  Copyright © 2020 Denis Avdeev. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> {
    
    struct Card: Identifiable {
        var id: Int
        var isFaceUp: Bool = true
        var isMatched: Bool = false
        var content: CardContent
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = (0..<numberOfPairsOfCards)
            .flatMap { pairIndex -> [Card] in
                let content = cardContentFactory(pairIndex)
                return [
                    Card(id: pairIndex * 2, content: content),
                    Card(id: pairIndex * 2 + 1, content: content)
                ]
            }
            .shuffled()
    }
    
    var cards: [Card]
    
    func choose(card: Card) {
        print("card chosen: \(card)")
    }
}
