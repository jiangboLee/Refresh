//
//  UIScrollViewRefresh.swift
//  JRefreshExanple
//
//  Created by Lee on 2018/8/21.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

private var headerKey: UInt8 = 0
private var footerKey: UInt8 = 0
public extension UIScrollView {
    public var header: JRefreshHeader? {
        set(newHeader) {
            if header != newHeader {
                //删除旧的，添加新的
                header?.removeFromSuperview()
                self.insertSubview(newHeader!, at: 0)
                // 存储新的
                objc_setAssociatedObject(self, &headerKey, newHeader, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        get {
            return objc_getAssociatedObject(self, &headerKey) as? JRefreshHeader
        }
    }
    public var footer: JRefreshFooter? {
        set(newFooter) {
            if footer != newFooter {
                //删除旧的，添加新的
                footer?.removeFromSuperview()
                self.insertSubview(newFooter!, at: 0)
                // 存储新的
                objc_setAssociatedObject(self, &footerKey, newFooter, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        get {
            return objc_getAssociatedObject(self, &footerKey) as? JRefreshFooter
        }
    }
}

extension NSObject {
    class func exchangeInstanceMethod1(_ method1: Selector, _ method2: Selector) {
        method_exchangeImplementations(class_getInstanceMethod(self, method1)!, class_getInstanceMethod(self, method2)!)
    }
    
    class func exchangeClassMehod(_ method1: Selector, _ method2: Selector) {
        method_exchangeImplementations(class_getClassMethod(self, method1)!, class_getClassMethod(self, method2)!)
    }
}

extension UITableView {
    
    
}

extension UICollectionView {
    
}

extension DispatchQueue {
    private static var onceTracker = [String]()
    
    open class func once(token: String, block:() -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if onceTracker.contains(token) {
            return
        }
        
        onceTracker.append(token)
        block()
    }
}

