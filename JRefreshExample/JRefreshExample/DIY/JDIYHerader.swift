//
//  JDIYHerader.swift
//  JRefreshExanple
//
//  Created by Lee on 2018/8/23.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

class JDIYHerader: JRefreshHeader {
 //MARK: - 重写方法
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brown
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
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
                label.text = "快下拉，看看美女~"
            case .Pulling:
                loading.stopAnimating()
                s.setOn(true, animated: true)
                label.text = "快放手，美女来啦~"
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
    //MARK: - 监听拖拽比例（控件被拖出来的比例）
    override var pullingPercent: CGFloat? {
        set(newPullingPercent) {
            super.pullingPercent = newPullingPercent
            guard let newPullingPercent = newPullingPercent else {
                return
            }
            let red = 1.0 - newPullingPercent * 0.5
            let green = 0.5 - newPullingPercent * 0.5
            let blue = 0.5 * newPullingPercent
            label.textColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        }
        get {
            return super.pullingPercent
        }
    }
}
extension JDIYHerader {
    //MARK: -  在这里做一些初始化配置（比如添加子控件）
    override func prepare() {
        super.prepare()
        
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
extension JDIYHerader {
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
