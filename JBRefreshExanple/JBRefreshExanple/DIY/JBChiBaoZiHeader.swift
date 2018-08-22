//
//  JBChiBaoZiHeader.swift
//  JBRefreshExanple
//
//  Created by Lee on 2018/8/22.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

class JBChiBaoZiHeader: JBRefreshGifHeader {

    override func prepare() {
        super.prepare()
        // 设置普通状态的动画图片
        var idleImages: Array<UIImage> = []
        for i in 1...60 {
            let image = UIImage(named: "dropdown_anim__000\(i)")
            idleImages.append(image!)
        }
        setImages(idleImages, .Idle)
        
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        var refreshingImages: Array<UIImage> = []
        for i in 1...3 {
            let image = UIImage(named: "dropdown_loading_0\(i)")
            refreshingImages.append(image!)
        }
        setImages(refreshingImages, .Pulling)
        // 设置正在刷新状态的动画图片
        setImages(refreshingImages, .Refreshing)
    }
}
