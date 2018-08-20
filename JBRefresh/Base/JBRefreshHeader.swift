//
//  JBRefreshHeader.swift
//  JBRefreshExanple
//
//  Created by Lee on 2018/8/20.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

class JBRefreshHeader: JBRefreshComponent {
    
    //MARK: - 创建header方法
    class func headerWithRefreshingBlock(_ refreshingBlock: Block) -> JBRefreshHeader {
        
        let cmp = self.init()
        cmp.refreshingBlock = refreshingBlock
        return cmp
    }
    ///这个key用来存储上一次下拉刷新成功的时间
    var lastUpdatedTimeKey: String?
    ///上一次下拉刷新成功的时间
    private(set) var lastUpdatedTime: Date?
    
    ///忽略多少scrollView的contentInset的top
    var ignoredScrollViewContentInsetTop: CGFloat = 0
    
    private var insetTDelta: CGFloat?
}

//MARK: - 覆盖父类的方法
extension JBRefreshHeader {
    override func prepare() {
        super.prepare()
        // 设置key
        lastUpdatedTimeKey = JBRefreshHead.lastUpdateTimeKey
        // 设置高度
        height = JBRefreshConst.headerHeight
    }
    override func placeSubviews() {
        super.placeSubviews()
        // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
        y = -height - ignoredScrollViewContentInsetTop
    }
    
    override func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
        guard let scrollView = scrollView, var scrollViewOriginalInset = scrollViewOriginalInset else {return}
        // 在刷新的refreshing状态
        if state == .Refreshing {
            // 暂时保留
            if window == nil {return}
            // sectionheader停留解决
            var insetT = -scrollView.offsetY > scrollViewOriginalInset.top ? -scrollView.offsetY : scrollViewOriginalInset.top
            insetT = insetT > (height + scrollViewOriginalInset.top) ? height + scrollViewOriginalInset.top : insetT
            scrollView.insetTop = insetT
            insetTDelta = scrollViewOriginalInset.top - insetT
            return
        }
        // 跳转到下一个控制器时，contentInset可能会变
        scrollViewOriginalInset = scrollView.inset
        
         // 当前的contentOffset
        let offsetY = scrollView.offsetY
        // 头部控件刚好出现的offsetY
        let happenOffsetY = -scrollViewOriginalInset.top
        
        // 如果是向上滚动到看不见头部控件，直接返回
        if offsetY > happenOffsetY {
            return
        }
        // 普通 和 即将刷新 的临界点
        let normal2pullingOffsetY = happenOffsetY - height
        let pullingPercent = (happenOffsetY - offsetY) / height
        // 如果正在拖拽
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            if self.state == .Idle && offsetY < normal2pullingOffsetY {
                
            }
        }
    }
}
















