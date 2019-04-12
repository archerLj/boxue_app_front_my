//
//  UIColor_Ext.swift
//  BoxueUIKit
//
//  Created by archerLj on 2019/4/10.
//  Copyright © 2019 NoOrganization. All rights reserved.
//

import Foundation

extension UIColor {
    public convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
    
    public convenience init(_ hex: Int) {
        assert(0...0xFFFFFF ~= hex, "the color hex value must between 0 and 0xFFFFFF")
        
        let r = (hex & 0xFF0000) >> 16
        let g = (hex & 0x00FF00) >> 8
        let b = (hex & 0x0000FF)
        
        self.init(red: r, green: g, blue: b)
    }
}
