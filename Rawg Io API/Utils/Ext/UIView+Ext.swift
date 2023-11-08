//
//  UIView+Ext.swift
//  Rawg Io API
//
//  Created by MAC on 21/08/23.
//

import UIKit


extension UIView
{
  func roundCorners(corners:UIRectCorner, radius: CGFloat)
  {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath 
    self.layer.mask = mask
  }
    
  func visiblity(gone: Bool, dimension: CGFloat = 0.0, attribute: NSLayoutConstraint.Attribute = .height) -> Void {
      if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
          constraint.constant = gone ? 0.0 : dimension
          self.layoutIfNeeded()
          self.isHidden = gone
      }
  }

}
