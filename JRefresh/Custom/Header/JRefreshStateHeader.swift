//
//  JRefreshStateHeader.swift
//  JRefreshExanple
//
//  Created by Lee on 2018/8/21.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

open class JRefreshStateHeader: JRefreshHeader {

    //MARK: - 刷新时间相关
    /// 利用这个block来决定显示的更新时间文字
    public var lastUpdatedTimeText: ((_ lastUpdatedTime: Date?) -> String)?
    /// 显示上一次刷新时间的label
    public lazy var lastUpdatedTimeLabel: UILabel = {
        let label = UILabel.J_lable()
        
        return label
    }()
    
    //MARK: - 状态相关
    ///文字距离圈圈、箭头的距离
    public var labelLeftInset: CGFloat = 0
    ///显示刷新状态的label
    public lazy var stateLabel: UILabel = {
        let label = UILabel.J_lable()
        
        return label
    }()
    
    ///所有状态对应的文字
    lazy var stateTitles: Dictionary = [:]
    
    ///key的处理
    override var lastUpdatedTimeKey: String? {
        set(newValue) {
            super.lastUpdatedTimeKey = newValue
            // 如果label隐藏了，就不用再处理
            if self.lastUpdatedTimeLabel.isHidden {
                return
            }
            let lastUpdatedTime = UserDefaults.standard.object(forKey: newValue ?? "") as? Date
            // 如果有block
            if let lastUpdatedTimeText = self.lastUpdatedTimeText {
                self.lastUpdatedTimeLabel.text = lastUpdatedTimeText(lastUpdatedTime)
                return
            }
            if lastUpdatedTime != nil {
                 // 1.获得年月日
                let calendar = NSCalendar(calendarIdentifier: .gregorian)
                let cmp1 = calendar?.components([.year, .month, .day, .hour, .minute], from: lastUpdatedTime!)
                let cmp2 = calendar?.components([.year, .month, .day, .hour, .minute], from: Date())
                
                //2.格式化日期
                let formatter = DateFormatter()
                var isToday = false
                if cmp1?.day == cmp2?.day {
                    formatter.dateFormat = " HH:mm"
                    isToday = true
                } else if cmp1?.year == cmp2?.year {
                    formatter.dateFormat = "MM-dd HH:mm"
                } else {
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                }
                let time = formatter.string(from: lastUpdatedTime!)
                
                // 3.显示日期
                lastUpdatedTimeLabel.text = String(format: "%@%@%@", Bundle.localizedString(JRefreshHead.lastTimeText), isToday ? Bundle.localizedString(JRefreshHead.dateTodayText) : "", time)
            } else {
                lastUpdatedTimeLabel.text = String(format: "%@%@", Bundle.localizedString(JRefreshHead.lastTimeText), Bundle.localizedString(JRefreshHead.noneLastDateText))
            }
            
        }
        get {
            return super.lastUpdatedTimeKey
        }
    }
    
    override open var state: JRefreshState {
        set(newState) {
            // 状态检查
            let oldState = self.state
            if oldState == newState {
                return
            }
            super.state = newState
            
             // 设置状态文字
            stateLabel.text = stateTitles[newState.hashValue] as? String
            // 重新设置key（重新显示时间）
            lastUpdatedTimeKey = JRefreshHead.lastUpdateTimeKey
        }
        get {
            return super.state
        }
    }  
    
    /// 设置state状态下的文字
    public func setTitle(_ title: String?, _ state: JRefreshState) {
        guard let title = title else { return }
        stateTitles[state.hashValue] = title
        stateLabel.text = stateTitles[state.hashValue] as? String
    }
}

extension JRefreshStateHeader {
    override open func prepare() {
        super.prepare()
        addSubview(lastUpdatedTimeLabel)
        addSubview(stateLabel)
        // 初始化间距
        labelLeftInset = JRefreshConst.labelLeftInset
        // 初始化文字
        setTitle(Bundle.localizedString(JRefreshHead.idleText), .Idle)
        setTitle(Bundle.localizedString(JRefreshHead.pullingText), .Pulling)
        setTitle(Bundle.localizedString(JRefreshHead.refreshingText), .Refreshing)
    }
    
    override open func placeSubviews() {
        super.placeSubviews()
        
        if stateLabel.isHidden {
            return
        }
        let noConstrainsOnStatusLabel = stateLabel.constraints.count == 0
        if lastUpdatedTimeLabel.isHidden {
            // 状态
            if noConstrainsOnStatusLabel {
                stateLabel.frame = bounds
            }
        } else {
            let stateLabelH = height * 0.5
            // 状态
            if noConstrainsOnStatusLabel {
                stateLabel.frame = CGRect(x: 0, y: 0, width: width, height: stateLabelH)
            }
            // 更新时间
            if lastUpdatedTimeLabel.constraints.count == 0 {
                lastUpdatedTimeLabel.frame = CGRect(x: 0, y: stateLabelH, width: width, height: height - stateLabelH)
            }
        }
    }
}


















