//
//  Array+Only.swift
//  Memorize
//
//  Created by Denis Avdeev on 09.06.2020.
//  Copyright © 2020 Denis Avdeev. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
