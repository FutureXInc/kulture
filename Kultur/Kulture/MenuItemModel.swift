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
    
    init (title: String, clickHandler: UIViewController){
        self.title = title
        self.clickHandler = clickHandler
    }
}
