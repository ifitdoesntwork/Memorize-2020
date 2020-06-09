//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Denis Avdeev on 08.06.2020.
//  Copyright © 2020 Denis Avdeev. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    
    func firstIndex(matching: Element) -> Int? {
        
        (0..<count)
            .first { self[$0].id == matching.id }
    }
}
