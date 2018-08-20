//
//  JBRefreshConst.swift
//  JBRefreshExanple
//
//  Created by Lee on 2018/8/20.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

struct JBRefreshConst {
    static let labelLeftInset: CGFloat = 25.0
    static let headerHeight: CGFloat = 54.0
    static let footerHeight: CGFloat = 44.0
    static let fastAnimationDuration = 0.25
    static let slowAnimationDuration = 0.4
}
struct JBRefreshKeyPath {
    static let contentOffset = "contentOffset"
    static let contentInset = "contentInset"
    static let contentSize = "contentSize"
    static let panState = "state"
}
struct JBRefreshHead {
    static let lastUpdateTimeKey = "JBRefreshHeadLastUpdateTimeKey"
    static let idleText = "JBRefreshHeadIdleText"
    static let pullingText = "JBRefreshHeadPullingText"
    static let refreshingText = "JBRefreshHeadRefreshingText"
}
