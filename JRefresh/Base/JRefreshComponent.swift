//
//  JRefreshComponent.swift
//  JRefreshExanple
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
public enum JRefreshState: Int {
    case Idle = 1
    case Pulling
    case Refreshing
    case WillRefresh
    case NoMoreData
}

open class JRefreshComponent: UIView {
    public typealias Block = (() -> ())?
   
    //MARK: - 刷新回调
    /// 正在刷新的回调
    var refreshingBlock: Block
    /// 回调对象
    var refreshingTarget: Any?
    /// 回调方法
    var refreshingAction: Selector?
    
    //MARK: - 刷新状态控制
    ///开始刷新后的回调(进入刷新状态后的回调)
    var beginRefreshingCompletionBlock: Block
    ///结束刷新的回调
    var endRefreshingCompletionBlock: Block
    ///是否正在刷新
    public var refreshing: Bool {
        return self.state == .Refreshing || self.state == .WillRefresh
    }
    /// 刷新状态 一般交给子类内部实现
    open var state: JRefreshState {
        didSet {
            // 加入主队列的目的是等setState:方法调用完毕、设置完文字后再去布局子控件
            DispatchQueue.main.async { [weak self] in
                self?.setNeedsLayout()
            }
        }
    }
    
    //MARK: - 交给子类去访问
    /// 记录scrollView刚开始的inset
    var scrollViewOriginalInset: UIEdgeInsets?
    ///父控件
    private(set) var scrollView: UIScrollView?
    
    //MARK: - 其他
    ///拉拽的百分比(交给子类重写)
    open var pullingPercent: CGFloat? {
        didSet {
            if self.refreshing {
                return
            }
            if self.automaticallyChangeAlpha ?? false {
                self.alpha = pullingPercent ?? 0
            }
        }
    }
    ///根据拖拽比例自动切换透明度
    public var automaticallyChangeAlpha: Bool? {
        willSet(_automaticallyChangeAlpha) {
            self.automaticallyChangeAlpha = _automaticallyChangeAlpha
            if self.refreshing {
                return
            }
            if _automaticallyChangeAlpha ?? false {
                self.alpha = self.pullingPercent ?? 0
            } else {
                self.alpha = 1.0
            }
        }
    }
    
    var pan: UIPanGestureRecognizer?
    
    //MARK: - 初始化
    override public init(frame: CGRect) {
        // 默认是普通状态
        state = .Idle
        super.init(frame: frame)
        // 准备工作
        prepare()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        placeSubviews()
        super.layoutSubviews()
    }
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        //如果不是UIScrollView，不做任何事情
        guard let newSuperview = newSuperview,
        newSuperview.isKind(of: UIScrollView.self)
        else { return }
        // 旧的父控件移除监听
        removeObservers()
        
        //设置宽度
        width = newSuperview.width
        //设置位置
        x = -(scrollView?.insetLeft ?? 0)
        // 记录UIScrollView
        scrollView = newSuperview as? UIScrollView
        // 设置永远支持垂直弹簧效果
        scrollView?.alwaysBounceVertical = true
        // 记录UIScrollView最开始的contentInset
        scrollViewOriginalInset = scrollView?.inset
        
        //添加监听
        addObservers()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        if state == .WillRefresh {
            // 预防view还没显示出来就调用了beginRefreshing
            state = .Refreshing
        }
    }
}

extension JRefreshComponent {
    //MARK: - 刷新状态控制
    /// 进入刷新状态
    @objc public func beginRefreshing() {
        UIView.animate(withDuration: JRefreshConst.fastAnimationDuration) {
            self.alpha = 1.0
        }
        self.pullingPercent = 1.0
        // 只要正在刷新，就完全显示
        if window != nil {
            state = .Refreshing
        } else {
            // 预防正在刷新中时，调用本方法使得header inset回置失败
            if state != .Refreshing {
                state = .WillRefresh
                 // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
                setNeedsDisplay()
            }
        }
    }
    public func beginRefreshingWithCompletionBlock(_ completionBlock: Block) {
        beginRefreshingCompletionBlock = completionBlock
        beginRefreshing()
    }
    public func endRefreshing() {
        DispatchQueue.main.async { [weak self] in
            self?.state = .Idle
        }
    }
    public func endRefreshingWithCompletionBlock(_ completionBlock: Block) {
        endRefreshingCompletionBlock = completionBlock
        endRefreshing()
    }
}
//MARK: - 交给子类们去实现
extension JRefreshComponent {
    ///初始化
    @objc open func prepare() {
        // 基本属性
        autoresizingMask = .flexibleWidth
        backgroundColor = UIColor.clear
    }
    ///摆放子控件frame
    @objc open func placeSubviews() {
        
    }
    ///当scrollView的contentOffset发生改变的时候调用
    @objc open func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        
    }
    ///当scrollView的contentSize发生改变的时候调用
    @objc open func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        
    }
    ///当scrollView的拖拽状态发生改变的时候调用
    @objc open func scrollViewPanStateDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        
    }
}
//MARK: - KVO监听
extension JRefreshComponent {
    func addObservers() {
        let options: NSKeyValueObservingOptions = [.new, .old]
        scrollView?.addObserver(self, forKeyPath: JRefreshKeyPath.contentOffset, options: options, context: nil)
        scrollView?.addObserver(self, forKeyPath: JRefreshKeyPath.contentSize, options: options, context: nil)
        pan = scrollView?.panGestureRecognizer
        pan?.addObserver(self, forKeyPath: JRefreshKeyPath.panState, options: options, context: nil)
    }
    func removeObservers() {
        superview?.removeObserver(self, forKeyPath: JRefreshKeyPath.contentOffset)
        superview?.removeObserver(self, forKeyPath: JRefreshKeyPath.contentSize)
        pan?.removeObserver(self, forKeyPath: JRefreshKeyPath.panState)
        pan = nil
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // 遇到这些情况就直接返回
        if !isUserInteractionEnabled {
            return
        }
        
        // 这个就算看不见也需要处理
        if keyPath == JRefreshKeyPath.contentSize {
            scrollViewContentSizeDidChange(change)
        }
        //看不见
        if isHidden {
            return
        }
        if keyPath == JRefreshKeyPath.contentOffset {
            scrollViewContentOffsetDidChange(change)
        } else if keyPath == JRefreshKeyPath.panState {
            scrollViewPanStateDidChange(change)
        }
    }
}

//MARK: - 公共方法
//MARK: - 设置回调对象和回调方法
extension JRefreshComponent {
    /// 设置回调对象和回调方法
    func setRefreshing(_ target: Any?, _ action: Selector?) {
        refreshingTarget = target
        refreshingAction = action
    }
    /// 触发回调（交给子类去调用）
    func executeRefreshingCallback() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshingBlock?()
            //###消息发送无法用swift表示，objc_msgsend
            self?.beginRefreshingCompletionBlock?()
        }
    }
}


