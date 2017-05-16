//
//  SlidingViewController.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/7/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var viewModel: MenuViewModel?
    var homeContainerViewController: HomeContainerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeContainerViewController?.contentViewController = viewModel?.getMenuViewItems()[1].clickHandler
        // Do any additional setup after loading the view.
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.estimatedRowHeight = 150
        
        tableview.dataSource = self
        tableview.delegate  = self
        tableview.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var tableview: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.getCount())!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = viewModel?.getCellAt(tableView: tableView, indexPath: indexPath)
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
//        let currentCell: ParentMenuItemTableViewCell = viewModel?.getCellAt(tableView: tableView, indexPath: indexPath) as! ParentMenuItemTableViewCell
//        currentCell.isSelectedIndicator.isHidden = false
//        
        
        let clickH: UIViewController = (viewModel?.getMenuViewItems()[indexPath.row].clickHandler)!
        
        if ((clickH as? LoginViewController) != nil) {
            homeContainerViewController?.dismiss(animated: true, completion: nil)
        } else {
            homeContainerViewController?.contentViewController = viewModel?.getMenuViewItems()[indexPath.row].clickHandler
        }
    }
}
