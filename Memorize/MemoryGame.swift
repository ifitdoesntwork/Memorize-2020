//
//  MemoryGame.swift
//  Memorize
//
//  Created by Denis Avdeev on 04.06.2020.
//  Copyright © 2020 Denis Avdeev. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    struct Card: Identifiable {
        var id: Int
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var isPreviouslySeen: Bool = false
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
    
    private(set) var cards: [Card]
    
    private(set) var score: Int = 0
    
    private var momentOfChoice = Date()
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices
                .filter { cards[$0].isFaceUp }
                .only
        }
        set {
            cards.indices.forEach {
                cards[$0].isFaceUp = $0 == newValue
            }
        }
    }
    
    mutating func choose(card: Card) {
        if
            let chosenIndex = cards.firstIndex(matching: card),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched
        {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                
                let timeFactor = max(
                    10 - Int(Date().timeIntervalSince(momentOfChoice)),
                    1
                )
                
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    score += 2 * timeFactor
                } else {
                    [chosenIndex, potentialMatchIndex].forEach { index in
                        if cards[index].isPreviouslySeen {
                            score -= 1 * timeFactor
                        }
                        cards[index].isPreviouslySeen = true
                    }
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            momentOfChoice = Date()
        }
    }
}
