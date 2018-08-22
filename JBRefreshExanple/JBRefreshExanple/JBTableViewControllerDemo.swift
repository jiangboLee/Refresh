//
//  JBTableViewControllerDemo.swift
//  JBRefreshExanple
//
//  Created by Lee on 2018/8/22.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

class JBTableViewControllerDemo: UITableViewController {

    var demoIndex: Int = 0
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        unowned let `self` = self
        switch demoIndex {
        case 0:
            tableView.header = JBRefreshStateHeader.headerWithRefreshingBlock({
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.header?.endRefreshing()
                })
            })
            tableView.header?.beginRefreshing()
        case 1:
            tableView.header = JBRefreshNormalHeader.headerWithRefreshingBlock({
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.header?.endRefreshing()
                })
            })
            tableView.header?.beginRefreshing()
        case 2:
            let header = JBRefreshNormalHeader.headerWithRefreshingBlock({
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.header?.endRefreshing()
                })
            })
            // 设置自动切换透明度(在导航栏下面自动隐藏)
            header.automaticallyChangeAlpha = true
            (header as! JBRefreshNormalHeader).lastUpdatedTimeLabel.isHidden = true
            header.beginRefreshing()
            tableView.header = header
        case 3:
            tableView.header = JBChiBaoZiHeader.headerWithRefreshingBlock({
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.header?.endRefreshing()
                })
            })
            tableView.header?.beginRefreshing()
        case 4:
            let header = JBChiBaoZiHeader.headerWithRefreshingBlock({
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.header?.endRefreshing()
                })
            })
            (header as! JBChiBaoZiHeader).stateLabel.isHidden = true
            (header as! JBChiBaoZiHeader).lastUpdatedTimeLabel.isHidden = true
            header.beginRefreshing()
            tableView.header = header
        case 5:
            let header = JBRefreshNormalHeader.headerWithRefreshingBlock({
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.header?.endRefreshing()
                })
            })
            // 设置文字
            (header as! JBRefreshNormalHeader).setTitle("lee", .Idle)
            (header as! JBRefreshNormalHeader).setTitle("jiang", .Pulling)
            (header as! JBRefreshNormalHeader).setTitle("bo", .Refreshing)
            // 设置字体
            (header as! JBRefreshNormalHeader).stateLabel.font = UIFont.systemFont(ofSize: 16)
            (header as! JBRefreshNormalHeader).lastUpdatedTimeLabel.font = UIFont.systemFont(ofSize: 14)
            // 设置颜色
            (header as! JBRefreshNormalHeader).stateLabel.textColor = UIColor.red
            (header as! JBRefreshNormalHeader).lastUpdatedTimeLabel.textColor = UIColor.blue
            header.beginRefreshing()
            tableView.header = header
        case 6:
            count = 10
            tableView.footer = JBRefreshAutoStateFooter.footerWithRefreshingBlock({
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                    self.count += 2
                    self.tableView.reloadData()
                    self.tableView.footer?.endRefreshing()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "JBTableViewControllerDemo", for: indexPath) 
        cell.textLabel?.text = "demo\(indexPath.row)"
        return cell
    }
 

}
