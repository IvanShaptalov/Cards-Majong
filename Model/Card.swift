//
//  Card.swift
//  CardsMajong
//
//  Created by van on 25.10.2023.
//

import Foundation


enum CardType: CaseIterable {
    case circle
    case cross
    case square
    case fill
}

enum CardColor: CaseIterable {
    case red
    case green
    case black
    case gray
    case brown
    case yellow
    case purple
    case orange
    case soda
}

typealias Card = (type: CardType, color: CardColor)
