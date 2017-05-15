//
//  MenuItemModel.swift
//  Kulture
//
//  Created by Bhalla, Kapil on 5/7/17.
//  Copyright © 2017 FutureXInc. All rights reserved.
//

import UIKit

class MenuItemModel: NSObject {

    var title: String?   //  Keeping it simple for now
    var clickHandler: UIViewController?
    var isSelected: Bool = false
    var menuImage: UIImage
    
    
    init (title: String, menuImage: UIImage, clickHandler: UIViewController){
        self.title = title
        self.menuImage = menuImage
        self.clickHandler = clickHandler
    }
}
