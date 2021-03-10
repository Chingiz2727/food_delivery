//
//  UITextField+Extension.swift
//  Pilican
//
//  Created by kairzhan on 3/4/21.
//

import UIKit

extension UITextField {
    
    func setBottomBorderWhite() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.grayBackground.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}


