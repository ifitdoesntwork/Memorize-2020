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
        case red
        case orange
        case yellow
        case green
        case cyan
        case blue
        case magenta
    }
    
    fileprivate enum Theme: CaseIterable {
        case halloween
        case animals
        case sports
        case faces
    }
    
    private var theme: Theme
    
    var color: Color {
        theme.color
    }
    
    var name: String {
        theme.name
    }
    
    @Published private var model: EmojiGame
    
    init() {
        theme = Theme.allCases
            .randomElement()!
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }

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
    
    func restart() {
        theme = Theme.allCases
            .shuffled()
            .first { $0 != theme }!
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
}

private extension EmojiMemoryGame.Theme {
    
    var name: String {
        "\(self)".capitalized
    }
    
    var emoji: [String] {
        switch self {
        case .halloween:
            return ["👻", "🎃", "🕷", "🧙‍♀️", "🦇"]
        case .animals:
            return ["🐼", "🐔", "🦄", "🦊"]
        case .sports:
            return ["🏀", "🏈", "⚾"]
        case .faces:
            return ["😀", "😢", "😉", "😍", "🙄"]
        }
    }
    
    /// `nil` means random number of cards
    var numberOfPairsOfCards: Int? {
        switch self {
        case .halloween:
            return 4
        case .animals:
            return 2
        case .sports:
            return 8 // intentionally broken theme
        case .faces:
            return nil
        }
    }
    
    var color: EmojiMemoryGame.Color {
        switch self {
        case .halloween:
            return .orange
        case .animals:
            return .green
        case .sports:
            return .blue
        case .faces:
            return .yellow
        }
    }
}
