//
//  JBRefreshComponent.swift
//  JBRefreshExanple
//
//  Created by LEE on 2018/8/18.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit


/// 刷新控件的状态
///
/// - Idle: 普通闲置状态
/// - Pulling: 松开就可以进行刷新的状态
/// - Refreshing: 正在刷新中的状态
/// - WillRefresh:  即将刷新的状态
/// - NoMoreData: 所有数据加载完毕，没有更多的数据了
enum JBRefreshState {
    case Idle
    case Pulling
    case Refreshing
    case WillRefresh
    case NoMoreData
}

class JBRefreshComponent: UIView {
    typealias <#type name#> = <#type expression#>
   

}
