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
        let id: Int
        let content: CardContent
        
        var isFaceUp: Bool = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                if isMatched {
                    stopUsingBonusTime()
                }
            }
        }

        var lastFaceUpDate: Date?
        var pastFaceUpTime: TimeInterval = 0
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
                
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                    [chosenIndex, potentialMatchIndex].forEach { index in
                        score += Int(10 * cards[index].bonusRemaining)
                    }
                } else {
                    [chosenIndex, potentialMatchIndex].forEach { index in
                        if cards[chosenIndex].pastFaceUpTime > 0 {
                            score -= Int(5 * (1 - cards[index].bonusRemaining))
                        }
                    }
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
}

// MARK: - Bonus Time

extension MemoryGame.Card {
    
    private var bonusTimeLimit: TimeInterval { 6 }
    
    private var faceUpTime: TimeInterval {
        pastFaceUpTime + (lastFaceUpDate.map { Date().timeIntervalSince($0) } ?? 0)
    }
    
    var bonusTimeRemaining: TimeInterval {
        max(0, bonusTimeLimit - faceUpTime)
    }
    
    var bonusRemaining: Double {
        (bonusTimeLimit > 0 && bonusTimeRemaining > 0)
            ? bonusTimeRemaining / bonusTimeLimit
            : 0
    }
    
    var isConsumingBonusTime: Bool {
        isFaceUp && !isMatched && bonusTimeRemaining > 0
    }
    
    private mutating func startUsingBonusTime() {
        if isConsumingBonusTime, lastFaceUpDate == nil {
            lastFaceUpDate = Date()
        }
    }
    
    private mutating func stopUsingBonusTime() {
        pastFaceUpTime = faceUpTime
        self.lastFaceUpDate = nil
    }
}
