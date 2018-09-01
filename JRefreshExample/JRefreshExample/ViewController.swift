//
//  ViewController.swift
//  JRefreshExanple
//
//  Created by LEE on 2018/8/18.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var headerArr: Array = ["默认下拉(只有刷新时间、状态)", "下拉带菊花、箭头", "隐藏时间", "GIF 刷新", "隐藏时间和状态", "下拉刷新 自定义文字", "自定义下拉视图", "默认下拉带⭕️动画"]
    var footerArr: Array = ["默认上拉", "上拉带loading", "静默加载+没有更多了", "上拉Gif", "上拉Gif(无文字状态)", "上拉,禁止默认自动刷新", "上拉自定义文案", "自定义上拉视图"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.header = JRefreshNormalHeader.headerWithRefreshingBlock({
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                self.tableView.reloadData()
                self.tableView.header?.endRefreshing()
            })
        })
        (tableView.header as? JRefreshNormalHeader)?.arrowViewNeedCircle = true
        tableView.header?.beginRefreshing()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return headerArr.count
        case 1:
            return footerArr.count
        default:
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = headerArr[indexPath.row]
        case 1:
            cell.textLabel?.text = footerArr[indexPath.row]
        default:
            cell.textLabel?.text = headerArr[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JTableViewControllerDemo") as! JTableViewControllerDemo
        tableVc.demoIndex = indexPath
        switch indexPath.section {
        case 0:
            tableVc.title = headerArr[indexPath.row]
        case 1:
            tableVc.title = footerArr[indexPath.row]
        default:
            tableVc.title = headerArr[indexPath.row]
        }
        navigationController?.pushViewController(tableVc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}


