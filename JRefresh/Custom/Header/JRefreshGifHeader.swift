//
//  JRefreshGifHeader.swift
//  JRefreshExanple
//
//  Created by Lee on 2018/8/22.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

open class JRefreshGifHeader: JRefreshStateHeader {

    lazy var gifView: UIImageView = {
        let gifView = UIImageView()
        return gifView
    }()
    
    lazy var stateImages: Dictionary = [:]
    lazy var stateDurations: Dictionary = [:]
    
    override open var pullingPercent: CGFloat? {
        set(newPullingPercent) {
            super.pullingPercent = newPullingPercent
            let image = stateImages[JRefreshState.Idle.hashValue] as? Array<UIImage>
            guard let images = image, images.count != 0, state == .Idle else {return}
            
            // 停止动画
            gifView.stopAnimating()
            // 设置当前需要显示的图片
            var index = Int(CGFloat(images.count) * (pullingPercent ?? 0))
            if index >= images.count {
                index = images.count - 1
            }
            gifView.image = images[index]
        }
        get {
            return super.pullingPercent
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
            
            // 根据状态做事情
            if newState == .Pulling || newState == .Refreshing {
                let image = stateImages[newState.hashValue] as? Array<UIImage>
                guard let images = image, images.count != 0 else {return}
                gifView.stopAnimating()
                if images.count == 1 { //单张图片
                    gifView.image = images.last
                } else {
                    gifView.animationImages = images
                    gifView.animationDuration = stateDurations[newState.hashValue] as? TimeInterval ?? 0.0
                    gifView.startAnimating()
                }
            } else if newState == .Idle {
                gifView.stopAnimating()
            }
        }
        get {
            return super.state
        }
    }
}

//MARK: - 公共方法
extension JRefreshGifHeader {
    public func setImages(_ images: Array<UIImage>, _ duration: TimeInterval, _ state: JRefreshState) {
        stateImages[state.hashValue] = images
        stateDurations[state.hashValue] = duration
        // 根据图片设置控件的高度
        let image = images.first
        if image?.size.height ?? 0 > height {
            height = image?.size.height ?? 0
        }
    }
    public func setImages(_ images: Array<UIImage>, _ state: JRefreshState) {
        setImages(images, Double(images.count) * 0.1, state)
    }
}

//MARK: - 实现父类的方法
extension JRefreshGifHeader {
    override open func prepare() {
        super.prepare()
        
        addSubview(gifView)
        // 初始化间距
        labelLeftInset = 20
    }
    override open func placeSubviews() {
        super.placeSubviews()
        
        if gifView.constraints.count > 0 {return}
        gifView.frame = bounds
        if stateLabel.isHidden && lastUpdatedTimeLabel.isHidden {
            gifView.contentMode = .center
        } else {
            gifView.contentMode = .right
            let stateWidth = stateLabel.textWidth()
            var timeWidth: CGFloat = 0.0
            if !lastUpdatedTimeLabel.isHidden {
                timeWidth = lastUpdatedTimeLabel.textWidth()
            }
            let textWidth = max(stateWidth, timeWidth)
            gifView.width = width * 0.5 - textWidth * 0.5 - labelLeftInset
        }
    }
}






