//
//  ViewController.swift
//  DYRefresh
//
//  Created by darrenyao on 16/7/18.
//  Copyright © 2016年 FlashWord. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.registerClass(UITableViewCell.self,  forCellReuseIdentifier:"cell")
        
        self.tableView.dy_setupHeader(target: self, selector: #selector(dy_updateData))
        self.tableView.dy_setupFooter(target: self, selector: #selector(dy_loadMoreData))
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.dy_header?.beginRefreshing()
//        dy_updateData()
    }
    
    func dy_updateData() {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
            var data = self.data
            for i in 0 ..< 20 {
                data.append("row: \(i)")
            }
            
            self.data = data
            self.tableView.reloadData()
            
            self.tableView.dy_header?.endRefreshing()
        })
    }
    
    func dy_loadMoreData() {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
            var data = self.data
            for i in 100 ..< 120 {
                data.append("row: \(i)")
            }
            
            self.data = data
            self.tableView.reloadData()
            
            self.tableView.dy_footer?.endRefreshingWithNoMoreData()
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}

