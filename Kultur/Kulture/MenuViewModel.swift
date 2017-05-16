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

    init (storyboard: UIStoryboard, forUser: User){
        storyBoard = storyboard
        theUser = forUser
    }
    
    
    public func getMenuViewItems () -> [MenuItemModel] {
        
        if (generatedMenuItems.count == 0){
            generatedMenuItems = MenuViewControllerHelper.generateMenuViewModel(storyBoard: self.storyBoard,
                                                                                aUser: self.theUser)
        }

        return generatedMenuItems
    }

    public func getCount () -> Int {
        return getMenuViewItems().count
    }
    
    public func getCellAt (tableView: UITableView, indexPath: IndexPath) -> UITableViewCell{
        
        var cell : UITableViewCell? = nil
        
        // first cell is the profile cell
        if (indexPath.row == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileTableViewCell", for: indexPath) as! UserProfileTableViewCell
            (cell as! UserProfileTableViewCell).userName.text = User._currentUser?.firstName
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "ParentMenuTableViewCell", for: indexPath) as! ParentMenuItemTableViewCell
            (cell as! ParentMenuItemTableViewCell).menuLable.text = generatedMenuItems[indexPath.row].title
            (cell as! ParentMenuItemTableViewCell).menuIcon.image = generatedMenuItems[indexPath.row].menuImage
        }
        
        //cell.isSelectedIndicator.isHidden = true
        
        // Hide the line seprator
        //0.f, cell.bounds.size.width, 0.f, 0.f);
        cell?.separatorInset = UIEdgeInsetsMake(0, (cell?.bounds.size.width)!, 0, 0 )
        
        return cell!
    }
    
    private var storyBoard: UIStoryboard!
    private var theUser: User!
    private var cellIdentifier: UITableViewCell?
    var generatedMenuItems: [MenuItemModel] = []
}
