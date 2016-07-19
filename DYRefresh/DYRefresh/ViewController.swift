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
        
        dy_setupRefresh(true, setFooter: false, scrollView: self.tableView)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.dy_header?.beginRefreshing()
    }
    
    override func dy_updateData() {
        var data = [String]()
        for i in 0 ..< 20 {
            data.append("row: \(i)")
        }
        
        self.data = data
        self.tableView.reloadData()
    }
    
    override func dy_loadMoreData() {
        
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

