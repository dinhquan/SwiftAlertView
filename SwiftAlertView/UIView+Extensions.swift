//
//  UIView+Extensions.swift
//  SwiftAlertViewDemo
//
//  Created by Eugene Goloboyar on 5/23/16.
//  Copyright © 2016 Dinh Quan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func retrieveFirstResponder() -> UIView? {
        if self.isFirstResponder() {
            return self
        }
        
        for subview in self.subviews {
            if let firstResponderView = subview.retrieveFirstResponder() {
                return firstResponderView
            }
        }
        
        return nil
    }
    
}