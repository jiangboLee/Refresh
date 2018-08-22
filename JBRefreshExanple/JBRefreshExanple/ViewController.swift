//
//  ViewController.swift
//  JBRefreshExanple
//
//  Created by LEE on 2018/8/18.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var demoArr: Array = ["正常下拉(只有刷新时间、状态)", "下拉带菊花、箭头", "隐藏时间", "GIF 刷新", "隐藏时间和状态", "下拉刷新 自定义文字"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.header = JBRefreshNormalHeader.headerWithRefreshingBlock({
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                self.tableView.reloadData()
                self.tableView.header?.endRefreshing()
            })
        })
        tableView.header?.beginRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoArr.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = demoArr[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableVc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "JBTableViewControllerDemo") as! JBTableViewControllerDemo
        tableVc.demoIndex = indexPath.row
        tableVc.title = demoArr[indexPath.row]
        navigationController?.pushViewController(tableVc, animated: true)
    }
}


