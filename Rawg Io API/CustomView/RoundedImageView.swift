//
//  RoundedImageView.swift
//  Rawg Io API
//
//  Created by MAC on 21/08/23.
//

import Foundation
import UIKit

@IBDesignable
class RoundedImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0.0 { didSet { setUpView() } }

    func setUpView() {
        self.clipsToBounds = true

        setTopCornerRadius(rect: self.bounds)
    }

    func setTopCornerRadius(rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners:[.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        self.layer.masksToBounds = true
    }
}
