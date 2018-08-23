//
//  JTableViewControllerDemo.swift
//  JRefreshExanple
//
//  Created by Lee on 2018/8/22.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

class JTableViewControllerDemo: UITableViewController {

    var demoIndex: Int = 0
    var count = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        switch demoIndex {
            //MARK: - 默认下拉(只有刷新时间、状态)
        case 0:
            tableView.header = JRefreshStateHeader.headerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.header?.endRefreshing()
                })
            })
            tableView.header?.beginRefreshing()
            //MARK: - 下拉带菊花、箭头
        case 1:
            tableView.header = JRefreshNormalHeader.headerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.header?.endRefreshing()
                })
            })
            tableView.header?.beginRefreshing()
            //MARK: - 隐藏时间
        case 2:
            let header = JRefreshNormalHeader.headerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.header?.endRefreshing()
                })
            })
            // 设置自动切换透明度(在导航栏下面自动隐藏)
            header.automaticallyChangeAlpha = true
            (header as! JRefreshNormalHeader).lastUpdatedTimeLabel.isHidden = true
            header.beginRefreshing()
            tableView.header = header
            //MARK: - GIF 刷新
        case 3:
            tableView.header = JChiBaoZiHeader.headerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.header?.endRefreshing()
                })
            })
            tableView.header?.beginRefreshing()
            //MARK: - 隐藏时间和状态
        case 4:
            let header = JChiBaoZiHeader.headerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.header?.endRefreshing()
                })
            })
            (header as! JChiBaoZiHeader).stateLabel.isHidden = true
            (header as! JChiBaoZiHeader).lastUpdatedTimeLabel.isHidden = true
            header.beginRefreshing()
            tableView.header = header
            //MARK: - 下拉刷新 自定义文字
        case 5:
            let header = JRefreshNormalHeader.headerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.header?.endRefreshing()
                })
            })
            // 设置文字
            (header as! JRefreshNormalHeader).setTitle("lee", .Idle)
            (header as! JRefreshNormalHeader).setTitle("jiang", .Pulling)
            (header as! JRefreshNormalHeader).setTitle("bo", .Refreshing)
            // 设置字体
            (header as! JRefreshNormalHeader).stateLabel.font = UIFont.systemFont(ofSize: 16)
            (header as! JRefreshNormalHeader).lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: 14)
            // 设置颜色
            (header as! JRefreshNormalHeader).stateLabel.textColor = UIColor.red
            (header as! JRefreshNormalHeader).lastUpdatedTimeLabel.textColor = UIColor.blue
            header.beginRefreshing()
            tableView.header = header
            //MARK: - 自定义下拉视图
        case 6:
            tableView.header = JDIYHerader.headerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.header?.endRefreshing()
                })
            })
            tableView.header?.beginRefreshing()
            //MARK: - 默认上拉
        case 7:
            count = 10
            tableView.footer = JRefreshAutoStateFooter.footerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.footer?.endRefreshing()
                })
            })
            //MARK: - 上拉带loading
        case 8:
            count = 10
            tableView.footer = JRefreshAutoNormalFooter.footerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.footer?.endRefreshing()
                })
            })
            //MARK: - 静默加载+没有更多了
        case 9:
            count = 20
            tableView.footer = JRefreshAutoNormalFooter.footerWithRefreshingBlock({ [weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 5
                    self.tableView.reloadData()
                    self.tableView.footer?.endRefreshing()
                    if self.count >= 40 {
                        self.tableView.footer?.endRefreshingWithNoMoreData()
                    }
                })
            })
            //当底部控件出现多少时就自动刷新 , 实际使用中我们会提前几个cell的高度
            (tableView.footer as? JRefreshAutoNormalFooter)?.triggerAutomaticallyRefreshPercent = -10
            //MARK: - 上拉Gif
        case 10:
            tableView.footer = JChiBaoZiFooter.footerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 5
                    self.tableView.reloadData()
                    self.tableView.footer?.endRefreshing()
                    if self.count >= 40 {
                        self.tableView.footer?.endRefreshingWithNoMoreData()
                    }
                })
            })
            //MARK: - 上拉Gif(无文字状态)
        case 11:
            tableView.footer = JChiBaoZiFooter.footerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 5
                    self.tableView.reloadData()
                    self.tableView.footer?.endRefreshing()
                    if self.count >= 40 {
                        self.tableView.footer?.endRefreshingWithNoMoreData()
                    }
                })
            })
            (tableView.footer as? JRefreshAutoGifFooter)?.refreshingTitleHidden = true
            //MARK: - 上拉,禁止默认自动刷新
        case 12:
            count = 10
            tableView.footer = JRefreshAutoNormalFooter.footerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.footer?.endRefreshing()
                })
            })
            (tableView.footer as? JRefreshAutoNormalFooter)?.automaticallyRefresh = false
            //MARK: - 上拉自定义文案
        case 13:
            count = 10
            tableView.footer = JRefreshAutoNormalFooter.footerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.footer?.endRefreshing()
                })
            })
            (tableView.footer as? JRefreshAutoNormalFooter)?.setTitle("bo", .NoMoreData)
            (tableView.footer as? JRefreshAutoNormalFooter)?.setTitle("jiang", .Refreshing)
            (tableView.footer as? JRefreshAutoNormalFooter)?.setTitle("lee", .Idle)
            (tableView.footer as? JRefreshAutoNormalFooter)?.stateLabel.textColor = UIColor.red
            //MARK: - 自定义上拉视图
        case 14:
            
            tableView.footer = JDIYAutoFooter.footerWithRefreshingBlock({[weak self] in
                guard let `self` = self else {return}
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 5
                    self.tableView.reloadData()
                    self.tableView.footer?.endRefreshing()
                    if self.count >= 40 {
                        self.tableView.footer?.endRefreshingWithNoMoreData()
                    }
                })
            })
        default:
            break
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JTableViewControllerDemo", for: indexPath)
        cell.textLabel?.text = "demo\(indexPath.row)"
        return cell
    }
 

}
