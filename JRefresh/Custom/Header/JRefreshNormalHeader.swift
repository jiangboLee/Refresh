//
//  JRefreshNormalHeader.swift
//  JRefreshExanple
//
//  Created by Lee on 2018/8/22.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

public class JRefreshNormalHeader: JRefreshStateHeader {

    public var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .gray {
        didSet {
            loadingView.activityIndicatorViewStyle = activityIndicatorViewStyle
            setNeedsLayout()
        }
    }
    public lazy var arrowView: UIImageView = {
        let arrowView = UIImageView(image: Bundle.arrowImage())
        addSubview(arrowView)
        return arrowView
    }()
    public lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: activityIndicatorViewStyle)
        loadingView.hidesWhenStopped = true
        addSubview(loadingView)
        return loadingView
    }()
    
    override var state: JRefreshState {
        set(newState) {
            // 状态检查
            let oldState = self.state
            if oldState == newState {
                return
            }
            super.state = newState
            
            // 根据状态做事情
            switch newState {
            case .Idle:
                if oldState == .Refreshing {
                    arrowView.transform = .identity
                    UIView.animate(withDuration: JRefreshConst.slowAnimationDuration, animations: {
                        self.loadingView.alpha = 0.0
                    }) { (finished) in
                        // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                        if newState != .Idle {return}
                        
                        self.loadingView.alpha = 1.0
                        self.loadingView.stopAnimating()
                        self.arrowView.isHidden = false
                    }
                } else {
                    loadingView.stopAnimating()
                    arrowView.isHidden = false
                    UIView.animate(withDuration: JRefreshConst.fastAnimationDuration) {
                        self.arrowView.transform = .identity
                    }
                }
            case .Pulling:
                loadingView.stopAnimating()
                arrowView.isHidden = false
                UIView.animate(withDuration: JRefreshConst.fastAnimationDuration) {
                    self.arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(0.000001 - Double.pi))
                }
            case .Refreshing:
                loadingView.alpha = 1.0 // 防止refreshing -> idle的动画完毕动作没有被执行
                loadingView.startAnimating()
                arrowView.isHidden = true
            default:
                break
            }
        }
        get {
            return super.state
        }
    }
}

extension JRefreshNormalHeader {
    override func placeSubviews() {
        super.placeSubviews()
        
        //箭头的中心点
        var arrowCenterX = width * 0.5
        if !stateLabel.isHidden {
            let stateWidth = stateLabel.textWidth()
            var timeWidth: CGFloat = 0.0
            if !lastUpdatedTimeLabel.isHidden {
                timeWidth = lastUpdatedTimeLabel.textWidth()
            }
            let textWidth = max(stateWidth, timeWidth)
            arrowCenterX -= textWidth / 2.0 + labelLeftInset
        }
        let arrowCenterY = height * 0.5
        let arrowCenter = CGPoint(x: arrowCenterX, y: arrowCenterY)
        
        // 箭头
        if arrowView.constraints.count == 0 {
            arrowView.size = arrowView.image?.size ?? .zero
            arrowView.center = arrowCenter
        }
        
        // 圈圈
        if loadingView.constraints.count == 0 {
            loadingView.center = arrowCenter
        }
        
        arrowView.tintColor = stateLabel.textColor
    }
}







