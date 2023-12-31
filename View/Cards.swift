//
//  Cards.swift
//  CardsMajong
//
//  Created by van on 25.10.2023.
//

import Foundation
import SwiftUI



// MARK: CARD
class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView {
    
    private var startTouchPoint: CGPoint!
    
    private var anchorPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        anchorPoint.x = touches.first!.location(in: window).x - frame.minX
        
        anchorPoint.y = touches.first!.location(in: window).y - frame.minY
        
        startTouchPoint = frame.origin
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.frame.origin.x = touches.first!.location(in: window).x - anchorPoint.x
        
        self.frame.origin.y = touches.first!.location(in: window).y - anchorPoint.y
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.frame.origin == startTouchPoint {
            flip()
        }
    }
    
    var isFlipped: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var flipCompletionHandler: ((FlippableView) -> Void)?
    
    func flip() {
        let fromView = isFlipped ? frontSideView : backSideView
        
        let toView = isFlipped ? backSideView : frontSideView
        
        UIView.transition(from: fromView, to: toView, duration: 0.4, options: [.transitionFlipFromTop], completion: {_ in
            // event handler
            self.flipCompletionHandler?(self)
        })
        isFlipped.toggle()
    }
    
    var color: UIColor!
    
    private let margin: Int = 10
    
    var cornerRadius = 20
    
    lazy var frontSideView: UIView = self.getFrontSideView()
    
    lazy var backSideView: UIView = self.getBackSideView()
    
    
    private func getFrontSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        
        let shapeView = UIView(frame: CGRect(x: margin, y: Int(margin), width: Int(self.bounds.width) - margin * 2, height: Int(self.bounds.height) - margin * 2))
        view.addSubview(shapeView)
        
        let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: color.cgColor)
        
        shapeView.layer.addSublayer(shapeLayer)
        
        view.layer.masksToBounds = true
        
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        
        return view
    }
    
    private func getBackSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        
        view.backgroundColor = .white
        
        switch ["circle", "line"].randomElement()! {
        case "circle":
            let layer = BackSideCircle(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
            
        case "line":
            let layer = BackSideLine(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        default:
            break
        }
        
        view.layer.masksToBounds = true
        
        view.layer.cornerRadius = CGFloat(cornerRadius)
        
        
        return view
    }
    
    init(frame: CGRect, color: UIColor){
        super.init(frame: frame)
        self.color = color
        
        setupBorders()
    }
    
    /// remove old views and add new;
    /// NEVER CALL draw METHOD DIRECTLY, ONLY
    /// setNeedsDisplay() or
    /// setNeedDisplay(_:)
    override func draw(_ rect: CGRect){
        backSideView.removeFromSuperview()
        frontSideView.removeFromSuperview()
        
        if isFlipped {
            self.addSubview(backSideView)
            self.addSubview(frontSideView)
        } else {
            self.addSubview(frontSideView)
            self.addSubview(backSideView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBorders(){
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
}

protocol FlippableView: UIView {
    var isFlipped: Bool {get set}
    var flipCompletionHandler: ((FlippableView) -> Void)? {get set}
    func flip()
}
