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
        
        let userProfileVC = storyboard.instantiateViewController(withIdentifier: "user_profile_view_controller") as! UserProfileViewController
        let userProfile = MenuItemModel(title: "User Profile",menuImage: #imageLiteral(resourceName: "user"),clickHandler: userProfileVC)
        returnMenuItems.append(userProfile)
        
        let timelineVC = storyboard.instantiateViewController(withIdentifier: "timeline_view_controller") as! TimeLineViewController
        // HEre are the menu items History TimeLine, Pending Approval, Reqeust Content, Invite.
        // Based of the cell for the user we will contain the title, handler and cell LAyout
        let parentTimeLine = MenuItemModel(title: "History TimeLine",menuImage: #imageLiteral(resourceName: "timeline_white"),clickHandler: timelineVC)
        returnMenuItems.append(parentTimeLine)
        
        
        // TODO - Pass the parameter to the timeline VC to configure. A data provider option
        let contentApprovalVC = storyboard.instantiateViewController(withIdentifier: "contentApproval_view_controller") as! ContentApprovalViewController
        let pendingApproval = MenuItemModel(title: "Pending Approval", menuImage: #imageLiteral(resourceName: "Checked_white"), clickHandler: contentApprovalVC)
        returnMenuItems.append(pendingApproval)
        
        
        let requestContentVC = storyboard.instantiateViewController(withIdentifier: "request_content_view_controller") as! RequestContentViewController
        let requestContent = MenuItemModel(title: "Request Content",  menuImage: #imageLiteral(resourceName: "Content"), clickHandler: requestContentVC)
        returnMenuItems.append(requestContent)
        
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        let signout = MenuItemModel(title: "Sign Out",  menuImage: #imageLiteral(resourceName: "signout"), clickHandler: loginViewController )
        returnMenuItems.append(signout)

        return returnMenuItems
    }
    
    class func generateKidsMenuItemViewModels (storyboard: UIStoryboard) -> [MenuItemModel]{
        var returnMenuItems: [MenuItemModel] = []
        
        let userProfileVC = storyboard.instantiateViewController(withIdentifier: "user_profile_view_controller") as! UserProfileViewController
        let userProfile = MenuItemModel(title: "User Profile",menuImage: #imageLiteral(resourceName: "user"),clickHandler: userProfileVC)
        returnMenuItems.append(userProfile)
        
        var timelineVC = storyboard.instantiateViewController(withIdentifier: "kid_timeline_view_controller") as! KidViewController
        timelineVC.filter = Filter.latest
        let thisWeek = MenuItemModel(title: "This Week",  menuImage: #imageLiteral(resourceName: "week_view"), clickHandler: timelineVC)

        returnMenuItems.append(thisWeek)
        
        // Based of the cell for the user we will contain the title, handler and cell LAyout
        timelineVC = storyboard.instantiateViewController(withIdentifier: "kid_timeline_view_controller") as! KidViewController
        timelineVC.filter = Filter.fun
        let parentTimeLine = MenuItemModel(title: "My Fun Stuff",  menuImage: #imageLiteral(resourceName: "timeline_white") , clickHandler: timelineVC)
        returnMenuItems.append(parentTimeLine)

        timelineVC = storyboard.instantiateViewController(withIdentifier: "kid_timeline_view_controller") as! KidViewController

        timelineVC.filter = Filter.liked
        let myFavourites = MenuItemModel(title: "My Favourites",  menuImage: #imageLiteral(resourceName: "Like"), clickHandler: timelineVC)
        returnMenuItems.append(myFavourites)
        
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        let signout = MenuItemModel(title: "Sign Out",  menuImage: #imageLiteral(resourceName: "signout"), clickHandler: loginViewController )
        returnMenuItems.append(signout)
        
        
        return returnMenuItems
    }
    
    class func generateFamilyMenuItemViewModels (storyboard: UIStoryboard) -> [MenuItemModel]{
        let userProfileVC = storyboard.instantiateViewController(withIdentifier: "user_profile_view_controller") as! UserProfileViewController
        let userProfile = MenuItemModel(title: "User Profile",menuImage: #imageLiteral(resourceName: "user_white"),clickHandler: userProfileVC)
        
        let timelineVC = storyboard.instantiateViewController(withIdentifier: "timeline_view_controller") as! TimeLineViewController
        let requestedContentsNavigationVC = storyboard.instantiateViewController(withIdentifier: "requested_contents_view_navigation_controller") as! UINavigationController
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        
        return [
            userProfile,
            MenuItemModel(title: "Content Requests",  menuImage: #imageLiteral(resourceName: "requestContent"), clickHandler: requestedContentsNavigationVC),
            MenuItemModel(title: "Timeline",  menuImage: #imageLiteral(resourceName: "timeline"), clickHandler: timelineVC),
            MenuItemModel(title: "Liked by Kids",  menuImage: #imageLiteral(resourceName: "Like"), clickHandler: timelineVC),
            MenuItemModel(title: "Sign Out",  menuImage: #imageLiteral(resourceName: "signout"), clickHandler: loginViewController )
        ]
    }

}
