//
//  AnimatedLabel.swift
//  CalendarApp
//
//  Created by David Wright on 1/15/21.
//

import UIKit

class AnimatedLabel: UILabel {
    
    enum AnimationStyle {
        case fromLeft, fromRight, fromTop, fromBottom
    }
    
    var auxLabel: UILabel?
    
    func animateText(to newText: String?,
                     duration: TimeInterval = 0.3,
                     animationStyle: AnimationStyle = .fromLeft,
                     distance: CGFloat = 50) {
        
        let newTextOrigin: CGPoint
        
        switch animationStyle {
        case .fromLeft: newTextOrigin = CGPoint(x: -distance, y: 0)
        case .fromRight: newTextOrigin = CGPoint(x: distance, y: 0)
        case .fromTop: newTextOrigin = CGPoint(x: 0, y: -distance)
        case .fromBottom: newTextOrigin = CGPoint(x: 0, y: distance)
        }
        
        if let auxLabel = auxLabel {
            text = auxLabel.text
            alpha = 1
            auxLabel.removeFromSuperview()
        }
        
        auxLabel = UILabel(frame: frame)
        auxLabel?.text = newText
        auxLabel?.font = font
        auxLabel?.textAlignment = textAlignment
        auxLabel?.textColor = textColor
        auxLabel?.backgroundColor = .clear
        
        auxLabel?.transform = CGAffineTransform(translationX: newTextOrigin.x, y: newTextOrigin.y)
        auxLabel?.alpha = 0
        superview?.addSubview(auxLabel!)
        
        UIView.animate(withDuration: duration / 5, delay: 0, options: .curveEaseInOut) {
            self.alpha = 0
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) {
            self.auxLabel?.transform = .identity
            self.auxLabel?.alpha = 1
        } completion: { finished in
            guard finished else { return }
            self.auxLabel?.removeFromSuperview()
            self.auxLabel = nil
            self.text = newText
            self.alpha = 1
        }
    }
}
