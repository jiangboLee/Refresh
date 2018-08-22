//
//  JBRefreshAutoStateFooter.swift
//  JBRefreshExanple
//
//  Created by Lee on 2018/8/22.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

class JBRefreshAutoStateFooter: JBRefreshAutoFooter {

    //MARK: - 状态相关
    ///文字距离圈圈、箭头的距离
    public var labelLeftInset: CGFloat = JBRefreshConst.labelLeftInset
    ///显示刷新状态的label
    lazy var stateLabel: UILabel = {
        let label = UILabel.jb_lable()
        addSubview(label)
        return label
    }()
    ///隐藏刷新状态的文字
    var refreshingTitleHidden: Bool = false
    ///所有状态对应的文字
    lazy var stateTitles: Dictionary = [:]
    
    override var state: JBRefreshState {
        set(newState) {
            // 状态检查
            let oldState = self.state
            if oldState == newState {
                return
            }
            super.state = newState
            
            if refreshingTitleHidden && newState == .Refreshing {
                stateLabel.text = nil
            } else {
                stateLabel.text = stateTitles[newState.hashValue] as? String
            }
        }
        get {
            return super.state
        }
    }
}
extension JBRefreshAutoStateFooter {
    /// 设置state状态下的文字
    func setTitle(_ title: String?, _ state: JBRefreshState) {
        guard let title = title else { return }
        stateTitles[state.hashValue] = title
        stateLabel.text = stateTitles[state.hashValue] as? String
    }
}
//MARK: - 重写父类的方法
extension JBRefreshAutoStateFooter {
    override func prepare() {
        super.prepare()
        // 初始化文字
        setTitle(Bundle.localizedString(JBRefreshAutoFoot.refreshingText), .Refreshing)
        setTitle(Bundle.localizedString(JBRefreshAutoFoot.noMoreDataText), .NoMoreData)
        setTitle(Bundle.localizedString(JBRefreshAutoFoot.idleText), .Idle)
        
        // 监听label
        stateLabel.isUserInteractionEnabled = true
        stateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(stateLabelClick)))
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        if stateLabel.constraints.count > 0 {
            return
        }
        // 状态标签
        stateLabel.frame = bounds
    }
}
extension JBRefreshAutoStateFooter {
    @objc fileprivate func stateLabelClick() {
        if state == .Idle {
            beginRefreshing()
        }
    }
}








