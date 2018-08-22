//
//  UILabelExtension.swift
//  JBRefreshExanple
//
//  Created by Lee on 2018/8/21.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

extension UILabel {
    class func jb_lable() -> UILabel {
        let label = self.init()
        label.font = JBRefreshLabelFont
        label.textColor = JBRefreshLabelTextColor
        label.autoresizingMask = .flexibleWidth
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        return label
    }
    
    public func textWidth() -> CGFloat {
        var stringWidth: CGFloat = 0.0
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        if text?.count ?? 0 > 0 {
            stringWidth = (text as NSString?)?.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil).width ?? 0
        }
        return stringWidth
    }
}
