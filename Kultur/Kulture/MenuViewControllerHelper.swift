//
//  MenuViewControllerHelper.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/8/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit

class MenuViewControllerHelper: NSObject {
    
    
    
    class func generateMenuViewModel (storyBoard: UIStoryboard,  aUser: User) -> [MenuItemModel] {
        var generatedMenuItems: [MenuItemModel] = []
        
        if (aUser.role == User.UserRole.Parent){
            print ("Set the menu items for parent role")
            //cellIdentifier =
            generatedMenuItems = generateParentMenuItemViewModels(storyboard: storyBoard)
        } else if (aUser.role == User.UserRole.Family) {
            print ("Set the menu items for family role")
            generatedMenuItems = generateFamilyMenuItemViewModels(storyboard: storyBoard)
        } else if (aUser.role == User.UserRole.Kid) {
            print ("Set the menu items for Kid role")
            generatedMenuItems = generateKidsMenuItemViewModels(storyboard: storyBoard)
        }
        
        return generatedMenuItems
    }
    
    class func generateParentMenuItemViewModels (storyboard: UIStoryboard) -> [MenuItemModel]{
        var returnMenuItems: [MenuItemModel] = []
        
        let timelineVC = storyboard.instantiateViewController(withIdentifier: "timeline_view_controller") as! TimeLineViewController
        
        // HEre are the menu items History TimeLine, Pending Approval, Reqeust Content, Invite.
        // Based of the cell for the user we will contain the title, handler and cell LAyout
        let parentTimeLine = MenuItemModel(title: "History TimeLine", clickHandler: timelineVC)
        returnMenuItems.append(parentTimeLine)
        
        
        // TODO - Pass the parameter to the timeline VC to configure. A data provider option
        let pendingApproval = MenuItemModel(title: "Pending Approval", clickHandler: timelineVC)
        returnMenuItems.append(pendingApproval)
        
        
        let requestContentVC = storyboard.instantiateViewController(withIdentifier: "request_content_view_controller") as! RequestContentViewController
        let requestContent = MenuItemModel(title: "Request Content", clickHandler: requestContentVC)
        returnMenuItems.append(requestContent)
        
        return returnMenuItems
    }
    
    class func generateKidsMenuItemViewModels (storyboard: UIStoryboard) -> [MenuItemModel]{
        var returnMenuItems: [MenuItemModel] = []
        
        let timelineVC = storyboard.instantiateViewController(withIdentifier: "timeline_view_controller") as! TimeLineViewController
        
        let thisWeek = MenuItemModel(title: "This Week", clickHandler: timelineVC)
        returnMenuItems.append(thisWeek)
        
        // Based of the cell for the user we will contain the title, handler and cell LAyout
        let parentTimeLine = MenuItemModel(title: "My FUN Stuff", clickHandler: timelineVC)
        returnMenuItems.append(parentTimeLine)
        
        let myFavourites = MenuItemModel(title: "My Favourites", clickHandler: timelineVC)
        returnMenuItems.append(myFavourites)
        
        
        return returnMenuItems
    }
    
    class func generateFamilyMenuItemViewModels (storyboard: UIStoryboard) -> [MenuItemModel]{
        var returnMenuItems: [MenuItemModel] = []
        
        let timelineVC = storyboard.instantiateViewController(withIdentifier: "timeline_view_controller") as! TimeLineViewController
        
        // Based of the cell for the user we will contain the title, handler and cell LAyout
        let familyContentRequest = MenuItemModel(title: "Content Requests", clickHandler: timelineVC)
        returnMenuItems.append(familyContentRequest)
        
        let contentSharedByMe = MenuItemModel(title: "Timeline", clickHandler: timelineVC)
        returnMenuItems.append(contentSharedByMe)

        let contentMarkedFavourite = MenuItemModel(title: "Liked by Kids", clickHandler: timelineVC)
        returnMenuItems.append(contentMarkedFavourite)
        
        return returnMenuItems
    }

}
