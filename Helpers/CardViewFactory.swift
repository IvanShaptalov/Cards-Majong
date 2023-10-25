//
//  CardViewFactory.swift
//  CardsMajong
//
//  Created by van on 25.10.2023.
//

import Foundation
import UIKit

class CardViewFactory {
    func get(_ shape: CardType, withSize size: CGSize, andColor color: CardColor) -> UIView {
        let frame = CGRect(origin: .zero, size: size)
        
        let viewColor = getViewColorBy(modelColor: color)
        
        switch shape {
        
        case .circle:
            return CardView<CircleShape>(frame: frame, color: viewColor)
            
        case .cross:
            return CardView<CrossShape>(frame: frame, color: viewColor)
            
        case .fill:
            return CardView<FillShape>(frame: frame, color: viewColor)
            
        case .square:
            return CardView<SquareShape>(frame: frame, color: viewColor)
            
        }
    }
    
    private func getViewColorBy(modelColor: CardColor) -> UIColor {
        switch modelColor {
        case .black:
            return .black
        case .brown:
            return .brown
        case .gray:
            return .gray
        case .green:
            return .green
        case .orange:
            return .orange
        case .soda:
            return .magenta
        case .purple:
            return .purple
        case .red:
            return .red
        case .yellow:
            return .yellow
            
        }
    }
}
