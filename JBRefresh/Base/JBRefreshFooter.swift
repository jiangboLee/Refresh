//
//  JBRefreshFooter.swift
//  JBRefreshExanple
//
//  Created by Lee on 2018/8/22.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

class JBRefreshFooter: JBRefreshComponent {
    ///忽略多少scrollView的contentInset的bottom
    public var ignoredScrollViewContentInsetBottom: CGFloat = 0
    //MARK: - 创建footer方法
    class func footerWithRefreshingBlock(_ refreshingBlock: Block) -> JBRefreshFooter {
        
        let cmp = self.init()
        cmp.refreshingBlock = refreshingBlock
        return cmp
    }
}

extension JBRefreshFooter {
    override func prepare() {
        super.prepare()
        // 设置自己的高度
        height = JBRefreshConst.footerHeight
    }
}
//MARK: - 公共方法
extension JBRefreshFooter {
    func endRefreshingWithNoMoreData() {
        DispatchQueue.main.async {[weak self] in
            self?.state = .NoMoreData
        }
    }
    func resetNoMoreData() {
        DispatchQueue.main.async {[weak self] in
            self?.state = .Idle
        }
    }
}









