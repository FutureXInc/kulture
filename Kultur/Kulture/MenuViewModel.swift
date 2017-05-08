//
//  MenuViewModel.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/7/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit

// This class holds the data model for the menu view controller to present
class MenuViewModel: NSObject {

    init (storyboard: UIStoryboard, forRole: User.UserRole){
        storyBoard = storyboard
        userRole = forRole
    }
    
    
    public func getMenuViewItems () -> [MenuItemModel] {
        
        if (generatedMenuItems.count == 0){
            if (userRole == User.UserRole.Parent){
                print ("Set the menu items for parent role")
                //cellIdentifier =
                generatedMenuItems = generateParentMenuItemViewModels()
            } else if (userRole == User.UserRole.Family) {
                print ("Set the menu items for family role")
            } else if (userRole == User.UserRole.Kid) {
                print ("Set the menu items for Kid role")
            }
        }

        return generatedMenuItems
    }

    public func getCount () -> Int {
        return getMenuViewItems().count
    }
    
    public func getCellAt (tableView: UITableView, indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParentMenuTableViewCell", for: indexPath) as! ParentMenuItemTableViewCell
        cell.menuLable.text = generatedMenuItems[indexPath.row].title
        return cell
    }
    
    private var storyBoard: UIStoryboard?
    private var userRole: User.UserRole?
    private var cellIdentifier: UITableViewCell?
    var generatedMenuItems: [MenuItemModel] = []
    
    
    private func generateParentMenuItemViewModels () -> [MenuItemModel]{
        var returnMenuItems: [MenuItemModel] = []
        
        let timelineVC = storyBoard?.instantiateViewController(withIdentifier: "timeline_view_controller") as! TimeLineViewController
        // Based of the cell for the user we will contain the title, handler and cell LAyout
        let parentTimeLine = MenuItemModel(title: "Shared Content", clickHandler: timelineVC)
        
        returnMenuItems.append(parentTimeLine)
        
        let requestContentVC = storyBoard?.instantiateViewController(withIdentifier: "request_content_view_controller") as! RequestContentViewController
        let requestContent = MenuItemModel(title: "Request new Content", clickHandler: requestContentVC)
        
        returnMenuItems.append(requestContent)
        
        return returnMenuItems
    }
}
