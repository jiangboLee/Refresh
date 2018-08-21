//
//  ViewController.swift
//  JBRefreshExanple
//
//  Created by LEE on 2018/8/18.
//  Copyright © 2018年 LEE. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var count = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.header = JBRefreshStateHeader.headerWithRefreshingBlock({
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
                self.count += 1
                self.tableView.reloadData()
                self.tableView.header?.endRefreshing()
            })
        })
        tableView.header?.beginRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = "demo1"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            break
        default:
            break
        }
    }
}


