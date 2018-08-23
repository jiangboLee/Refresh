//
//  JDIYFooter.swift
//  JRefreshExanple
//
//  Created by Lee on 2018/8/23.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

class JDIYAutoFooter: JRefreshAutoFooter {

    //MARK: - 重写方法
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brown
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "快上拉，看看美女~"
        return label
    }()
    lazy var s: UISwitch = {
        let s = UISwitch()
        return s
    }()
    lazy var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        return loading
    }()
    
    //MARK: - 监听控件的刷新状态
    override var state: JRefreshState {
        set(newState) {
            // 状态检查
            let oldState = self.state
            if oldState == newState {
                return
            }
            super.state = newState
            
            switch newState {
            case .Idle:
                loading.stopAnimating()
                s.setOn(false, animated: true)
                label.text = "快上拉，看看美女~"
            case .NoMoreData:
                loading.stopAnimating()
                s.setOn(true, animated: true)
                label.text = "不好意思，美女领完啦~"
            case .Refreshing:
                loading.startAnimating()
                s.setOn(true, animated: true)
                label.text = "骗你的，美女走了~"
            default:
                break
            }
        }
        get {
            return super.state
        }
    }
}
extension JDIYAutoFooter {
    //MARK: -  在这里做一些初始化配置（比如添加子控件）
    override func prepare() {
        super.prepare()
        
        height = 50
        addSubview(label)
        addSubview(s)
        addSubview(loading)
    }
    //MARK: - 在这里设置子控件的位置和尺寸
    override func placeSubviews() {
        super.placeSubviews()
        
        label.frame = bounds
        s.center = CGPoint(x: 50, y: height * 0.5)
        loading.center = CGPoint(x: bounds.width - 80, y: height * 0.5)
    }
}
extension JDIYAutoFooter {
    override func scrollViewPanStateDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanStateDidChange(change)
        
    }
    override func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change)
        
    }
    override func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
        
    }
}
