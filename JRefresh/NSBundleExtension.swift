//
//  NSBundleExtension.swift
//  JRefreshExanple
//
//  Created by Lee on 2018/8/21.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

public extension Bundle {
    public class func refreshBunle() -> Bundle {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        return Bundle(path: Bundle(for: JRefreshComponent.self).path(forResource: "JRefresh", ofType: "bundle")!)!
    }
    
    public class func arrowImage() -> UIImage {
        return UIImage(contentsOfFile: refreshBunle().path(forResource: "arrow@2x", ofType: "png")!)!.withRenderingMode(.alwaysTemplate)
    }
    
    public class func localizedString(_ key: String) -> String {
        return localizedString(key, nil)
    }
    public class func localizedString(_ key: String, _ value: String?) -> String {
        // （iOS获取的语言字符串比较不稳定）目前框架只处理en、zh-Hans、zh-Hant三种情况，其他按照系统默认处理
        var language = NSLocale.preferredLanguages.first ?? ""
        if language.hasPrefix("en") {
            language = "en"
        } else if language.hasPrefix("zh") {
            if (language.range(of: "Hans") != nil) {
                language = "zh-Hans"
            } else {
                language = "zh-Hant"
            }
        } else {
            language = "en"
        }
        let bundle = Bundle(path: refreshBunle().path(forResource: language, ofType: "lproj")!)
        let value = bundle?.localizedString(forKey: key, value: value, table: nil)
        return Bundle.main.localizedString(forKey: key, value: value, table: nil)
    }
}
