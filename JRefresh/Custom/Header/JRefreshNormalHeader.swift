//
//  JRefreshNormalHeader.swift
//  JRefreshExanple
//
//  Created by Lee on 2018/8/22.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

open class JRefreshNormalHeader: JRefreshStateHeader {

    public var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .gray {
        didSet {
            loadingView.activityIndicatorViewStyle = activityIndicatorViewStyle
            setNeedsLayout()
        }
    }
    public lazy var arrowView: UIImageView = {
        let arrowView = UIImageView(image: Bundle.arrowImage())
        arrowView.contentMode = .scaleAspectFill
        return arrowView
    }()
    public lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
    
    /// 箭头是否需要旋转圆弧动画
    public var arrowViewNeedCircle: Bool = false {
        didSet {
            circleLayer.isHidden = !arrowViewNeedCircle
        }
    }
    public lazy var circleLayer: CAShapeLayer = {
        let circleLayer = CAShapeLayer()
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.gray.cgColor
        circleLayer.lineWidth = 1.5
        circleLayer.lineCap = kCALineCapRound
        circleLayer.strokeStart = 0
        circleLayer.speed = 2
        circleLayer.bounds = CGRect(origin: .zero, size: CGSize(width: 36, height: 36))
        circleLayer.path = UIBezierPath(arcCenter: CGPoint(x: 18, y: 18), radius: 18, startAngle: CGFloat(-Double.pi / 2.0), endAngle: CGFloat(Double.pi * 3.0 / 2.0), clockwise: true).cgPath
        circleLayer.isHidden = true
        return circleLayer
    }()
    
    override open var pullingPercent: CGFloat? {
        set(newPullingPercent) {
            super.pullingPercent = newPullingPercent
            if arrowViewNeedCircle {
                UIView.animate(withDuration: 0.1) {
                    self.circleLayer.strokeEnd = newPullingPercent ?? 1
                    self.arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * 2.0 * (newPullingPercent ?? 1 >= 1 ? 1.0 : newPullingPercent ?? 1) - CGFloat(Double.pi) )
                }
            }
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
                        if self.arrowViewNeedCircle {self.circleLayer.isHidden = false}
                    }
                } else {
                    loadingView.stopAnimating()
                    arrowView.isHidden = false
                    if arrowViewNeedCircle {
                        circleLayer.isHidden = false
                        UIView.animate(withDuration: JRefreshConst.fastAnimationDuration) {
                            self.arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                        }
                    } else {
                        
                        UIView.animate(withDuration: JRefreshConst.fastAnimationDuration) {
                            self.arrowView.transform = .identity
                        }
                    }
                }
            case .Pulling:
                loadingView.stopAnimating()
                arrowView.isHidden = false
                if arrowViewNeedCircle {
                    circleLayer.isHidden = false
                } else {
                    UIView.animate(withDuration: JRefreshConst.fastAnimationDuration) {
                        self.arrowView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                    }
                }
            case .Refreshing:
                if arrowViewNeedCircle {circleLayer.isHidden = true}
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
    override open func prepare() {
        super.prepare()
        addSubview(arrowView)
        addSubview(loadingView)
        layer.addSublayer(circleLayer)
    }
    override open func placeSubviews() {
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
//            arrowView.size = arrowView.image?.size ?? .zero
            arrowView.bounds = CGRect(origin: .zero, size: arrowView.image?.size ?? .zero)
            arrowView.center = arrowCenter
            circleLayer.position = arrowCenter
        }
        
        // 圈圈
        if loadingView.constraints.count == 0 {
            loadingView.center = arrowCenter
        }
        
        arrowView.tintColor = stateLabel.textColor
    }
}







